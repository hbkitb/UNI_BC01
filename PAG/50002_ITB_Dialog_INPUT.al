page 50002 "ITB_Dialog_INPUT"
{

    PageType = StandardDialog;     //List;
    //SourceTable = Customer;
    Caption = 'Angiv debitor konto+reference';
    DelayedInsert = true;
    InsertAllowed = false;
    //ApplicationArea = All;
    //UsageCategory = Lists;

    layout
    {
        area(content)
        {

            //repeater(Generel)
            //{

            field(CustAccount; CustAccount)
            {
                ApplicationArea = All;
                Caption = 'Debitorkonto';

                trigger OnValidate()
                begin
                    //rec."No." := CustAccount;
                    //if PayInvoice <> 0 then
                    //    PayCard := 0;
                end;

            }


            field(OrdreReference; OrdreReference)
            {
                ApplicationArea = All;
                Caption = 'OrdreReference';

                trigger OnValidate()
                begin
                    //if PayCard <> 0 then
                    //    PayInvoice := 0;
                end;


            }

            /*
            field(Rest; Rest)
            {
                ApplicationArea = All;
                Caption = 'REST';
                Editable = false;
                //Visible = false;


            }
            */



            // }

        }
    }



    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                action(ACPayment)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Angiv debitor konto+reference';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = '';

                    trigger OnAction()
                    var
                        GenJnlBatch: Record "Gen. Journal Batch";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                        Betal: Decimal;
                        BetalDAN: Decimal;
                    begin
                        //Gloal_Var.TermOrd_Save();
                        // end;
                        Message('i page');
                        Message(CustAccount);
                        Message(Antal);
                        Message(ItemTerm);

                        Gloal_Var.TermOrd_Save(CustAccount, Antal, ItemTerm);

                        //290822 - Her skal salgsordre oprettes:


                    end; //Payinvoice større end 0

                    //Rec.CalcFields("Balance (LCY)");
                    //Rest := Rec."Balance (LCY)";


                    //HBK / ITB - 200122 - Print Kvittering
                    // if (Betal <> 0) OR (BetalDAN <> 0) then begin
                    //Message(Rec."No.");
                    //AC_Cust := Rec;
                    //Message(AC_Cust."No.");



                    //Rec."Telex No." := Voucher;
                    //Message(Rec."Telex No.");
                    //AC_Cust.Modify;
                    //Message(Rec."No.");
                    //Message(AC_Cust."Telex No.");
                    //260822  Report.run(Report::Kvit_AC, true, true, Rec);
                    //Report.run(Report::Kvit_AC, true, true, Rec);
                    //end
                    //HBK / ITB - 200122 - Print Kvittering

                    /*
                    CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                    if IsSimplePage then
                        if GeneralLedgerSetup."Post with Job Queue" then
                            NewDocumentNo()
                        else
                            SetDataForSimpleModeOnPost;
                    SetJobQueueVisibility();
                    CurrPage.Update(false);
                    */
                    //end;
                }
            }
        }
    }



    trigger OnOpenPage()

    var
        CustSaldo: Record Customer;

    begin

        //260922
        clear(TermDiv);
        TermDiv.Reset;
        TermDiv.SetRange(UserId_, UserId);
        if TermDiv.FindSet then begin
            TermDiv.A := DelChr(TermDiv.A, '<', ' ');
            CustAccount := TermDiv.A;
        end;
        //260922

        //260222        Gloal_Var.TermOrd_Get(CustAccount, Antal, ItemTerm);
        //Her kommer beregning af saldo
        /*
        CustSaldo.Reset;
        CustSaldo.SetRange("No.", Rec."Bill-to Customer No.");
        if CustSaldo.FindSet then begin
            CustSaldo.CalcFields("Balance (LCY)");
            Rest := CustSaldo."Balance (LCY)";
        end;
        */

        //Rec.CalcFields("Balance (LCY)");
        //Rest := Rec."Balance (LCY)";





    end;

    trigger OnClosePage()

    begin
        //260922  Gloal_Var.TermOrd_Save(CustAccount, Antal, ItemTerm);

        GenPostSetupImp();
    end;

    var
        Item: Record Item;
        //h 
        //SalesPrice: Record "Sales Price";
        SalesPrice: Record "Price List Line";
        Counter: Integer;
        NoInd: Integer;
        COOPSign: Integer;
        OrdKart: Record "Sales Header";
        OrdLinie: Record "Sales Line";
        DebKart: Record Customer;
        FakKart: Record Customer;
        LagKart: Record Item;
        OrdNum: Text[20];
        Number: Text[20];
        Dag: Integer;
        "Måned": Integer;
        "År": Integer;
        DebKonto: Text[20];
        FakKonto: Text[20];
        PgBestil: Text[20];
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        PrepmtMgt: Codeunit "Prepayment Mgt.";
        HideValidationDialog: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
        LinieNo: Decimal;
        LagKonto: Text[20];
        //h
        //SalesPriceFind: Codeunit "Sales Price Calc. Mgt.";
        SalesPriceFind: Codeunit "Price Calculation Mgt.";  //081020
        PostNr: Integer;
        SagsPost: Record "Job Ledger Entry";
        "Løbenummer": Integer;
        Dato: Date;
        KostPris: Decimal;
        KostPrisRV: Decimal;
        "KostBeløb": Decimal;
        "KostBeløbRV": Decimal;
        GenPostSetup: Record "General Posting Setup";
        GenVareSetup: Record "Inventory Posting Setup";
        VendPost: Record "Vendor Posting Group";
        CustPost: Record "Customer Posting Group";
        Employee: Record Employee;
        ComLineOld: Record "Comment Line";
        ComLine: Record "Sales Comment Line";
        LineNo: Decimal;
        LineNoOld: Decimal;
        KreKart: Record Vendor;

        AMedlem: Boolean;
        btoA: Boolean;
        BUdenFak: Boolean;
        Lin1: Boolean;
        Deb03: Record Customer;
        DebStd: Record Customer;
        OIOReference: Text[20];
        Department: Record "Dimension Value";
        Centre: Record "Dimension Value";
        Purpose: Record "Dimension Value";

        DimMgt: Codeunit DimensionManagement; //270821
        TempDimSetEntry: Record "Dimension Set Entry" temporary; //270821
        DebName: Text[50];
        GenJourLine: Record "Gen. Journal Line";
        JLineNumber: Integer;
        Inputvar: List of [Text[20]];  //260822
        GlobalVar: Codeunit Global_Var;  //290822
        myinput: dialog;
        myinputtxt: Text[20];
        diatest: Boolean; //290822
        QtyFelt03: Decimal;
        TermDiv: Record Term_div; // 260922


    //260922
    local procedure GenPostSetupImp()

    var

    begin
        clear(TermDiv);
        TermDiv.Reset;
        TermDiv.SetRange(UserId_, UserId);
        if TermDiv.FindSet then
            repeat

                TermDiv.A := DelChr(TermDiv.A, '<', ' ');
                TermDiv.B := DelChr(TermDiv.B, '>', ' ');

                TermDiv.C := DelChr(TermDiv.C, '<', ' ');
                TermDiv.D := DelChr(TermDiv.D, '>', ' ');

                TermDiv.E := DelChr(TermDiv.E, '<', ' ');
                TermDiv.F := DelChr(TermDiv.F, '>', ' ');

                TermDiv.G := DelChr(TermDiv.G, '<', ' ');
                TermDiv.H := DelChr(TermDiv.H, '>', ' ');


                OIOReference := '';
                FakKonto := CustAccount;     //260922  TermDiv.A;     //Account_Felt01;

                OrdKart.RESET;
                OrdKart.SetRange("No.", FakKonto);
                OrdKart.SetRange("Document Type", OrdKart."Document Type"::Order);
                if OrdKart.FindSet then begin
                    OrdNum := OrdKart."No.";
                    //rette salgslinier på eksisterende salgsordre-Evt. lige oprettet.
                    FindItemExistSales();
                    Lin1 := false;

                end
                else begin // check for debitor og opret salgsordre på debitor
                    DebKart.RESET;
                    DebKart.SetRange("No.", FakKonto);
                    if DebKart.FindSet then begin
                        ;
                    end
                    else
                        FakKonto := '99999999';


                    if Lin1 = true then begin
                        Clear(DebKart);
                        DebKart.RESET;
                        DebKart.SetRange("No.", FakKonto);
                        if DebKart.FindSet then begin
                            //opret salgsordre og første linie
                            FakKonto := DebKart."No.";

                            Clear(OrdKart);

                            "OrdKart"."No." := '';
                            "OrdKart".Init();


                            "OrdKart"."Document Type" := "OrdKart"."Document Type"::Order;

                            "OrdKart".Validate("Sell-to Customer No.", DebKart."No.");
                            //"OrdKart".Validate("Bill-to Customer No.", head.Custaccount); //130122 se nedenstående linie
                            //"OrdKart".Validate("Bill-to Customer No.", DebKart."Bill-to Customer No.");  //130122

                            if OrdKart."VAT Registration No." = '' then
                                OrdKart."VAT Registration No." := '00000000';

                            if ((OrdKart."Bill-to Customer No." <> '') and (DebKart."VAT Registration No." <> '')) then
                                OrdKart."VAT Registration No." := DebKart."VAT Registration No.";

                            "OrdKart"."Salesperson Code" := DebKart."Salesperson Code";
                            OrdKart."Sell-to E-Mail" := DebKart."E-Mail";

                            OrdKart.Status := OrdKart.Status::Open;  //alternativt frigivet/released                        

                            OrdKart."Shipment Date" := Today;

                            //if FakKart."Fax No." <> '' then
                            OrdKart."Your Reference" := OIOReference;   //FakKart."Fax No.";
                                                                        //if FakKart."Fax No." <> '' then
                            OrdKart."External Document No." := OIOReference;   //FakKart."Fax No.";

                            //if OIOReference = '' then begin
                            //    OrdKart."Your Reference" := Felt01;
                            //    OrdKart."External Document No." := Felt01;
                            //end;

                            if OIOReference = '' then
                                OrdKart."External Document No." := '.';

                            if OrdKart."Sell-to Contact" = '' then
                                OrdKart."Sell-to Contact" := '.';

                            OrdKart."OIOUBL-GLN" := DebKart.GLN;



                            "OrdKart".Insert(true);

                            OrdNum := OrdKart."No.";
                            message(Format(OrdNum));
                            //Commit();
                            //Så kommer ordrelinie

                        end;  //lin1 = false
                    end;

                    FindItem();

                    lin1 := false;



                end;
                // så oprettes salgsordre på fakkonto ->
                //videre
                Lin1 := false;

                TermDiv.Delete;
            until TermDiv.Next = 0;

    end;

    procedure FindItem()

    var
        EanItem: Record Item;
        EanItem02: Record Item;
        EanTemp: Text[50];
        SalesItemNo: Code[20];
        Robert: Text[30];
        Colli: Decimal;
        PantLine: Record "Sales Line";
    //LineNo: Decimal;

    begin
        Robert := '';
        SalesItemNo := '';
        EanTemp := TermDiv.B; //B=Department/item   //Rec.EANNr;
        EanItem.Reset;
        EanItem.SetRange(EANNr, TermDiv.B);   //TermDiv.B);     //Rec.EANNr);


        if EanItem.FindSet then
            SalesItemNo := EanItem."No."
        else begin

            EanItem.Reset;
            EanItem.SetRange(EANNr02, TermDiv.B);        //TermDiv.B);   //Rec.EANNr);
            if EanItem.FindSet then
                SalesItemNo := EanItem."No."

        end;

        if SalesItemNo = '' then begin
            if ((StrLen(TermDiv.B) >= 15) and (CopyStr(TermDiv.B, 1, 1) = 'ù')) then
                IF CopyStr(TermDiv.B, 1, 2) = 'ùC' THEN begin
                    Robert := copystr(TermDiv.B, 4, 20);
                    TermDiv.B := CopyStr(TermDiv.B, 4, 16);
                end
                else begin
                    Robert := CopyStr(TermDiv.B, 2, 20);
                    TermDiv.B := CopyStr(TermDiv.B, 2, 16);
                end
            else begin
                IF ((StrLen(TermDiv.B) > 15) and (CopyStr(TermDiv.B, 1, 1) = ']')) then begin
                    IF CopyStr(TermDiv.B, 1, 2) = ']C' THEN begin
                        Robert := copystr(TermDiv.B, 4, 20);
                        TermDiv.B := CopyStr(TermDiv.B, 4, 16);
                    end
                    else begin
                        Robert := CopyStr(TermDiv.B, 2, 20);
                        TermDiv.B := CopyStr(TermDiv.B, 2, 16);
                    end
                end
                else begin
                    IF StrLen(TermDiv.B) > 15 THEN begin
                        Robert := CopyStr(TermDiv.B, 1, 20);
                        TermDiv.B := CopyStr(TermDiv.B, 1, 16);

                    end;
                end;
            end;

        end;

        if SalesItemNo = '' then begin
            IF StrLen(TermDiv.B) = 16 then
                TermDiv.B := Robert;
            //SubStr(SalesLine.EANNr,1,StrLen(SalesLine.EANNr)-4)
        end;
        EanTemp := TermDiv.B;  //Så skal varenummer mv på linien og valideres mv



        //else begin  testing 121021
        EanItem02.Reset;
        EanItem02.SetRange(EANNr02, TermDiv.B);    //Rec.EANNr);

        if EanItem02.FindSet then begin
            //tidligere
            LineNo := LineNo + 10000;
            Message('ordlin: ' + Format(OrdNum));
            Clear(OrdLinie);
            OrdLinie.Init;
            OrdLinie.Validate("Document Type", OrdLinie."Document Type"::Order);
            OrdLinie.Validate("Document No.", OrdNum);
            OrdLinie.Type := OrdLinie.Type::Item;
            OrdLinie."Line No." := LineNo;
            OrdLinie.Validate(Type);
            //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;
            OrdLinie.Validate("No.", EanItem02."No.");
            OrdLinie.Validate("Unit Price");
            //HUSK EVALUATE ANTAL
            Evaluate(QtyFelt03, TermDiv.E); //F svarer til Balance01 //Balance01_Felt03);
            Colli := EanItem02.KartAntal;

            if Colli <> 0 then begin

                OrdLinie.QtyColli := QtyFelt03;  //1 pr. 121121 Colli;
                OrdLinie.Validate(Quantity, QtyFelt03 * Colli);

            end
            else begin
                OrdLinie.QtyColli := 0;
                OrdLinie.Validate(Quantity, QtyFelt03);
            end;

            //310822  OrdLinie.Validate(Quantity, QtyFelt03);
            OrdLinie.Validate("Line Discount %");
            //"Sales Line".Validate("Unit Price", FSLines.SalesPrice); //301221
            OrdLinie.Validate("Line No.", LineNo);
            OrdLinie.Mangde := EanItem02.Mangde;  //HBK / ITB - 091221
            OrdLinie.EANNr := EanItem02.EANNr;

            OrdLinie.Insert(true);
            //tidligere

            SalesItemNo := EanItem02."No.";


            //Pantlinie
            if StrLen(EanItem02.PantItem) > 2 then begin
                Clear(PantLine);
                PantLine.Init;
                //310822  LineNo := OrdLinie."Line No." - 500;
                PantLine.Validate("Line No.", LineNo - 500);

                PantLine.Validate("Document Type", OrdLinie."Document Type");
                PantLine.Validate("Document No.", OrdLinie."Document No.");

                PantLine.Type := PantLine.Type::Item;
                PantLine.Validate("No.", EanItem02.PantItem);

                PantLine.Validate(Quantity, OrdLinie.Quantity);
                PantLine.QtyColli := 0;

                //141221 PantLine.EANNr := EanItem.EANNr;
                PantLine.EANNr := EanItem02.EANNr;  //141221

                PantLine.Insert(true);

                OrdLinie.PantLineNo := PantLine."Line No.";
                OrdLinie.Modify;
                //PantLinie                            


            end;  //if pantitem


            //141221  end;

            //Rec.EANNr := EanTemp;//
        end
        else begin
            EanItem.Reset;
            EanItem.SetRange(EANNr, TermDiv.B);    //Rec.EANNr);

            if EanItem.FindSet then begin

                //tidligere
                //tidligere
                LineNo := LineNo + 10000;
                Message('ordlin: ' + Format(OrdNum));
                Clear(OrdLinie);
                OrdLinie.Init;
                OrdLinie.Validate("Document Type", OrdLinie."Document Type"::Order);
                OrdLinie.Validate("Document No.", OrdNum);
                OrdLinie.Type := OrdLinie.Type::Item;
                OrdLinie."Line No." := LineNo;
                OrdLinie.Validate(Type);
                //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;
                OrdLinie.Validate("No.", EanItem."No.");
                OrdLinie.Validate("Unit Price");
                //HUSK EVALUATE ANTAL
                Evaluate(QtyFelt03, TermDiv.E);     //F er Balance01_Felt03);
                //Colli := EanItem02.KartAntal;


                OrdLinie.QtyColli := 0;
                OrdLinie.Validate(Quantity, QtyFelt03);


                //310822  OrdLinie.Validate(Quantity, QtyFelt03);
                OrdLinie.Validate("Line Discount %");
                //"Sales Line".Validate("Unit Price", FSLines.SalesPrice); //301221
                OrdLinie.Validate("Line No.", LineNo);
                OrdLinie.Mangde := EanItem.Mangde;  //HBK / ITB - 091221
                OrdLinie.EANNr := EanItem.EANNr;

                OrdLinie.Insert(true);
                //tidligere

                SalesItemNo := EanItem."No.";


                //Pantlinie
                if StrLen(EanItem.PantItem) > 2 then begin
                    Clear(PantLine);
                    PantLine.Init;
                    //310822  LineNo := OrdLinie."Line No." - 500;
                    PantLine.Validate("Line No.", LineNo - 500);

                    PantLine.Validate("Document Type", OrdLinie."Document Type");
                    PantLine.Validate("Document No.", OrdLinie."Document No.");

                    PantLine.Type := PantLine.Type::Item;
                    PantLine.Validate("No.", EanItem.PantItem);

                    PantLine.Validate(Quantity, OrdLinie.Quantity);
                    PantLine.QtyColli := 0;

                    //141221 PantLine.EANNr := EanItem.EANNr;
                    PantLine.EANNr := EanItem.EANNr;  //141221

                    PantLine.Insert(true);

                    OrdLinie.PantLineNo := PantLine."Line No.";
                    OrdLinie.Modify;
                    //PantLinie                            


                end;  //if pantitem
            end
            //tidligere

            //121121
            //121121
            else begin
                EanItem.Reset;
                EanItem.SetRange("No.", TermDiv.B);    //TermDiv.B);   //Rec.EANNr);
                if EanItem.FindSet then begin
                    //tidligere
                    LineNo := LineNo + 10000;
                    Message('ordlin: ' + Format(OrdNum));
                    Clear(OrdLinie);
                    OrdLinie.Init;
                    OrdLinie.Validate("Document Type", OrdLinie."Document Type"::Order);
                    OrdLinie.Validate("Document No.", OrdNum);
                    OrdLinie.Type := OrdLinie.Type::Item;
                    OrdLinie."Line No." := LineNo;
                    OrdLinie.Validate(Type);
                    //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;
                    OrdLinie.Validate("No.", EanItem."No.");
                    OrdLinie.Validate("Unit Price");
                    //HUSK EVALUATE ANTAL
                    Evaluate(QtyFelt03, TermDiv.E);      //Balance01_Felt03);
                    //Colli := EanItem02.KartAntal;


                    OrdLinie.QtyColli := 0;
                    OrdLinie.Validate(Quantity, QtyFelt03);


                    //310822  OrdLinie.Validate(Quantity, QtyFelt03);
                    OrdLinie.Validate("Line Discount %");
                    //"Sales Line".Validate("Unit Price", FSLines.SalesPrice); //301221
                    OrdLinie.Validate("Line No.", LineNo);
                    OrdLinie.Mangde := EanItem.Mangde;  //HBK / ITB - 091221
                    OrdLinie.EANNr := EanItem.EANNr;

                    OrdLinie.Insert(true);
                    //tidligere

                    SalesItemNo := EanItem."No.";



                    //Pantlinie
                    if StrLen(EanItem.PantItem) > 2 then begin
                        Clear(PantLine);
                        PantLine.Init;
                        //310822  LineNo := OrdLinie."Line No." - 500;
                        PantLine.Validate("Line No.", LineNo - 500);

                        PantLine.Validate("Document Type", OrdLinie."Document Type");
                        PantLine.Validate("Document No.", OrdLinie."Document No.");

                        PantLine.Type := PantLine.Type::Item;
                        PantLine.Validate("No.", EanItem.PantItem);

                        PantLine.Validate(Quantity, OrdLinie.Quantity);
                        PantLine.QtyColli := 0;

                        //141221 PantLine.EANNr := EanItem.EANNr;
                        PantLine.EANNr := EanItem.EANNr;  //141221

                        PantLine.Insert(true);

                        OrdLinie.PantLineNo := PantLine."Line No.";
                        OrdLinie.Modify;
                        //PantLinie                            


                    end;  //if pantitem                    

                    //tidligere

                end;
                //121121                          

                //121121

            end;
            //end; testing 121021
        end;

        Lin1 := false;
    end;


    procedure FindItemExistSales()

    var
        EanItem: Record Item;
        EanItem02: Record Item;
        EanTemp: Text[50];
        SalesItemNo: Code[20];
        Robert: Text[30];
        Colli: Decimal;
        PantLine: Record "Sales Line";
    //LineNo: Decimal;

    begin
        Robert := '';
        SalesItemNo := '';
        EanTemp := TermDiv.B;  //TermDiv.B;   //Rec.EANNr;
        EanItem.Reset;
        EanItem.SetRange(EANNr, TermDiv.B);     //Rec.EANNr);


        if EanItem.FindSet then
            SalesItemNo := EanItem."No."
        else begin

            EanItem.Reset;
            EanItem.SetRange(EANNr02, TermDiv.B);   //Rec.EANNr);
            if EanItem.FindSet then
                SalesItemNo := EanItem."No."

        end;

        if SalesItemNo = '' then begin
            if ((StrLen(TermDiv.B) >= 15) and (CopyStr(TermDiv.B, 1, 1) = 'ù')) then
                IF CopyStr(TermDiv.B, 1, 2) = 'ùC' THEN begin
                    Robert := copystr(TermDiv.B, 4, 20);
                    TermDiv.B := CopyStr(TermDiv.B, 4, 16);
                end
                else begin
                    Robert := CopyStr(TermDiv.B, 2, 20);
                    TermDiv.B := CopyStr(TermDiv.B, 2, 16);
                end
            else begin
                IF ((StrLen(TermDiv.B) > 15) and (CopyStr(TermDiv.B, 1, 1) = ']')) then begin
                    IF CopyStr(TermDiv.B, 1, 2) = ']C' THEN begin
                        Robert := copystr(TermDiv.B, 4, 20);
                        TermDiv.B := CopyStr(TermDiv.B, 4, 16);
                    end
                    else begin
                        Robert := CopyStr(TermDiv.B, 2, 20);
                        TermDiv.B := CopyStr(TermDiv.B, 2, 16);
                    end
                end
                else begin
                    IF StrLen(TermDiv.B) > 15 THEN begin
                        Robert := CopyStr(TermDiv.B, 1, 20);
                        TermDiv.B := CopyStr(TermDiv.B, 1, 16);

                    end;
                end;
            end;

        end;

        if SalesItemNo = '' then begin
            IF StrLen(TermDiv.B) = 16 then
                TermDiv.B := Robert;
            //SubStr(SalesLine.EANNr,1,StrLen(SalesLine.EANNr)-4)
        end;
        EanTemp := TermDiv.B;  //Så skal varenummer mv på linien og valideres mv



        //else begin  testing 121021
        EanItem02.Reset;
        EanItem02.SetRange(EANNr02, TermDiv.B);    //Rec.EANNr);

        if EanItem02.FindSet then begin
            //tidligere
            LineNo := LineNo + 10000;
            Message('ordlin: ' + Format(OrdNum));
            Clear(OrdLinie);
            OrdLinie.SetRange("Document No.", OrdNum);
            OrdLinie.SetRange("No.", EanItem02."No.");
            if OrdLinie.FindSet then begin
                //Ved eksisterende ordrelinie  -  050922
                Evaluate(QtyFelt03, TermDiv.E);     //Balance01_Felt03);
                Colli := EanItem02.KartAntal;

                if Colli <> 0 then begin

                    OrdLinie.QtyColli := QtyFelt03;  //1 pr. 121121 Colli;
                    OrdLinie.Validate(Quantity, QtyFelt03 * Colli);

                end
                else begin
                    OrdLinie.QtyColli := 0;
                    OrdLinie.Validate(Quantity, QtyFelt03);
                end;
                OrdLinie.Modify;
                //ved eksist  - 050922

            end
            else begin   //opret ny hvis ordrelinie ikke findes
                Clear(OrdLinie);
                OrdLinie.SetRange("Document No.", OrdNum);
                OrdLinie.SetRange("Document Type", OrdLinie."Document Type"::Order);
                LineNo := 0;
                if OrdLinie.FindSet then begin
                    if OrdLinie."Line No." > LineNo then
                        LineNo := OrdLinie."Line No.";
                end;
                LineNo := LineNo + 10000;
                Clear(OrdLinie);
                OrdLinie.Init;
                OrdLinie.Validate("Document Type", OrdLinie."Document Type"::Order);
                OrdLinie.Validate("Document No.", OrdNum);
                OrdLinie.Type := OrdLinie.Type::Item;
                OrdLinie."Line No." := LineNo;
                OrdLinie.Validate(Type);
                //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;
                OrdLinie.Validate("No.", EanItem02."No.");
                OrdLinie.Validate("Unit Price");
                //HUSK EVALUATE ANTAL
                Evaluate(QtyFelt03, TermDiv.E);       //Balance01_Felt03);
                Colli := EanItem02.KartAntal;

                if Colli <> 0 then begin

                    OrdLinie.QtyColli := QtyFelt03;  //1 pr. 121121 Colli;
                    OrdLinie.Validate(Quantity, QtyFelt03 * Colli);

                end
                else begin
                    OrdLinie.QtyColli := 0;
                    OrdLinie.Validate(Quantity, QtyFelt03);
                end;

                //310822  OrdLinie.Validate(Quantity, QtyFelt03);
                OrdLinie.Validate("Line Discount %");
                //"Sales Line".Validate("Unit Price", FSLines.SalesPrice); //301221
                OrdLinie.Validate("Line No.", LineNo);
                OrdLinie.Mangde := EanItem02.Mangde;  //HBK / ITB - 091221
                OrdLinie.EANNr := EanItem02.EANNr;

                OrdLinie.Insert(true);
                //tidligere

                SalesItemNo := EanItem02."No.";


                //Pantlinie
                if StrLen(EanItem02.PantItem) > 2 then begin
                    Clear(PantLine);
                    PantLine.Init;
                    //310822  LineNo := OrdLinie."Line No." - 500;
                    PantLine.Validate("Line No.", LineNo - 500);

                    PantLine.Validate("Document Type", OrdLinie."Document Type");
                    PantLine.Validate("Document No.", OrdLinie."Document No.");

                    PantLine.Type := PantLine.Type::Item;
                    PantLine.Validate("No.", EanItem02.PantItem);

                    PantLine.Validate(Quantity, OrdLinie.Quantity);
                    PantLine.QtyColli := 0;

                    //141221 PantLine.EANNr := EanItem.EANNr;
                    PantLine.EANNr := EanItem02.EANNr;  //141221

                    PantLine.Insert(true);

                    OrdLinie.PantLineNo := PantLine."Line No.";
                    OrdLinie.Modify;
                    //PantLinie                            


                end;  //if pantitem


                //141221  end;
            end;
            //Rec.EANNr := EanTemp;//
        end
        else begin
            EanItem.Reset;
            EanItem.SetRange(EANNr, TermDiv.B);    //Rec.EANNr);

            if EanItem.FindSet then begin

                //tidligere
                //tidligere
                LineNo := LineNo + 10000;
                Message('ordlin: ' + Format(OrdNum));
                Clear(OrdLinie);
                OrdLinie.Init;
                OrdLinie.Validate("Document Type", OrdLinie."Document Type"::Order);
                OrdLinie.Validate("Document No.", OrdNum);
                OrdLinie.Type := OrdLinie.Type::Item;
                OrdLinie."Line No." := LineNo;
                OrdLinie.Validate(Type);
                //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;
                OrdLinie.Validate("No.", EanItem."No.");
                OrdLinie.Validate("Unit Price");
                //HUSK EVALUATE ANTAL
                Evaluate(QtyFelt03, TermDiv.E);       //Balance01_Felt03);
                //Colli := EanItem02.KartAntal;


                OrdLinie.QtyColli := 0;
                OrdLinie.Validate(Quantity, QtyFelt03);


                //310822  OrdLinie.Validate(Quantity, QtyFelt03);
                OrdLinie.Validate("Line Discount %");
                //"Sales Line".Validate("Unit Price", FSLines.SalesPrice); //301221
                OrdLinie.Validate("Line No.", LineNo);
                OrdLinie.Mangde := EanItem.Mangde;  //HBK / ITB - 091221
                OrdLinie.EANNr := EanItem.EANNr;

                OrdLinie.Insert(true);
                //tidligere

                SalesItemNo := EanItem."No.";


                //Pantlinie
                if StrLen(EanItem.PantItem) > 2 then begin
                    Clear(PantLine);
                    PantLine.Init;
                    //310822  LineNo := OrdLinie."Line No." - 500;
                    PantLine.Validate("Line No.", LineNo - 500);

                    PantLine.Validate("Document Type", OrdLinie."Document Type");
                    PantLine.Validate("Document No.", OrdLinie."Document No.");

                    PantLine.Type := PantLine.Type::Item;
                    PantLine.Validate("No.", EanItem.PantItem);

                    PantLine.Validate(Quantity, OrdLinie.Quantity);
                    PantLine.QtyColli := 0;

                    //141221 PantLine.EANNr := EanItem.EANNr;
                    PantLine.EANNr := EanItem.EANNr;  //141221

                    PantLine.Insert(true);

                    OrdLinie.PantLineNo := PantLine."Line No.";
                    OrdLinie.Modify;
                    //PantLinie                            


                end;  //if pantitem
            end
            //tidligere

            //121121
            //121121
            else begin
                EanItem.Reset;
                EanItem.SetRange("No.", TermDiv.B);   //Rec.EANNr);
                if EanItem.FindSet then begin
                    //tidligere
                    LineNo := LineNo + 10000;
                    Message('ordlin: ' + Format(OrdNum));
                    Clear(OrdLinie);
                    OrdLinie.Init;
                    OrdLinie.Validate("Document Type", OrdLinie."Document Type"::Order);
                    OrdLinie.Validate("Document No.", OrdNum);
                    OrdLinie.Type := OrdLinie.Type::Item;
                    OrdLinie."Line No." := LineNo;
                    OrdLinie.Validate(Type);
                    //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;
                    OrdLinie.Validate("No.", EanItem."No.");
                    OrdLinie.Validate("Unit Price");
                    //HUSK EVALUATE ANTAL
                    Evaluate(QtyFelt03, TermDiv.E);     //Balance01_Felt03);
                    //Colli := EanItem02.KartAntal;


                    OrdLinie.QtyColli := 0;
                    OrdLinie.Validate(Quantity, QtyFelt03);


                    //310822  OrdLinie.Validate(Quantity, QtyFelt03);
                    OrdLinie.Validate("Line Discount %");
                    //"Sales Line".Validate("Unit Price", FSLines.SalesPrice); //301221
                    OrdLinie.Validate("Line No.", LineNo);
                    OrdLinie.Mangde := EanItem.Mangde;  //HBK / ITB - 091221
                    OrdLinie.EANNr := EanItem.EANNr;

                    OrdLinie.Insert(true);
                    //tidligere

                    SalesItemNo := EanItem."No.";



                    //Pantlinie
                    if StrLen(EanItem.PantItem) > 2 then begin
                        Clear(PantLine);
                        PantLine.Init;
                        //310822  LineNo := OrdLinie."Line No." - 500;
                        PantLine.Validate("Line No.", LineNo - 500);

                        PantLine.Validate("Document Type", OrdLinie."Document Type");
                        PantLine.Validate("Document No.", OrdLinie."Document No.");

                        PantLine.Type := PantLine.Type::Item;
                        PantLine.Validate("No.", EanItem.PantItem);

                        PantLine.Validate(Quantity, OrdLinie.Quantity);
                        PantLine.QtyColli := 0;

                        //141221 PantLine.EANNr := EanItem.EANNr;
                        PantLine.EANNr := EanItem.EANNr;  //141221

                        PantLine.Insert(true);

                        OrdLinie.PantLineNo := PantLine."Line No.";
                        OrdLinie.Modify;
                        //PantLinie                            


                    end;  //if pantitem                    

                    //tidligere

                end;
                //121121                          

                //121121

            end;
            //end; testing 121021
        end;

        Lin1 := false;
    end;
    //260922
    var
        Rest: Decimal;
        PayInvoice: Decimal;
        PayCard: Decimal;
        CustAccount: Text[20];
        Antal: Text[20];
        ItemTerm: Text[20];
        OrdreReference: Text[20];

        PayJour: Record "Gen. Journal Line";
        PayLine: Integer;

        Voucher: Code[20];  //200122
        Gloal_Var: Codeunit Global_Var;  //200122
                                         //AC_Cust: Record Customer temporary; //210122


}