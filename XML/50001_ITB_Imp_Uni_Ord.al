xmlport 50001 "50001_Imp_Uni_Ord"
{
    //Import af ekstra felter fra C5 Lagerkart

    Caption = 'Import Envina Kursus/ordre';
    DefaultFieldsValidation = false;
    Direction = Import;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    FileName = 'S:\C5WIN\Envina\*.csv';
    Format = VariableText;
    Permissions =;
    TextEncoding = WINDOWS;
    UseRequestPage = false;

    schema
    {

        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'ImpOrdKart_UNI';
                UseTemporary = true;
                textelement(Account_Felt01)
                {
                }
                textelement(Department_Felt02)
                {
                }
                textelement(Balance01_Felt03)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt04)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt05)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt06)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt07)
                {
                    MinOccurs = Zero;
                }

                textelement(Felt08)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt09)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt10)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt11)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt12)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt13)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt14)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt15)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt16)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt17)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt18)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt19)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt20)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt21)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt22)
                {
                    MinOccurs = Zero;
                }


                trigger OnBeforeInsertRecord()
                var
                //counter: Integer;

                begin

                    Counter := Counter + 1;   // pga fejl i indsæt på temp. tabel integer.
                    Integer.Number := Counter;


                    IF Account_Felt01 <> '' THEN begin

                        GenPostSetupImp;  //bogopsæt
                        Lin1 := false;

                    end;


                end;
            }
        }
    }

    requestpage
    {

    }

    trigger OnInitXmlPort()
    begin

        Lin1 := true;
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Import er færdig !');  //
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


    /*
    EVALUATE(Dag,COPYSTR(Felt02,1,2));
    EVALUATE(Måned,COPYSTR(Felt02,4,2));
    EVALUATE(År,COPYSTR(Felt02,7,4));
    Dato := DMY2DATE(Dag,Måned,År);  //Dato oprettet

    EVALUATE(Løbenummer,Felt01);
    */


    local procedure GenPostSetupImp()

    var

    begin
        Felt07 := DelChr(Felt07, '<', ' ');
        Felt07 := DelChr(Felt07, '>', ' ');

        Felt08 := DelChr(Felt08, '<', ' ');
        Felt08 := DelChr(Felt08, '>', ' ');

        Felt20 := DelChr(Felt20, '<', ' ');
        Felt20 := DelChr(Felt20, '>', ' ');

        Felt16 := DelChr(Felt16, '<', ' ');
        Felt16 := DelChr(Felt16, '>', ' ');

        OIOReference := '';
        FakKonto := Account_Felt01;

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
        EanTemp := Department_Felt02;   //Rec.EANNr;
        EanItem.Reset;
        EanItem.SetRange(EANNr, Department_Felt02);     //Rec.EANNr);


        if EanItem.FindSet then
            SalesItemNo := EanItem."No."
        else begin

            EanItem.Reset;
            EanItem.SetRange(EANNr02, Department_Felt02);   //Rec.EANNr);
            if EanItem.FindSet then
                SalesItemNo := EanItem."No."

        end;

        if SalesItemNo = '' then begin
            if ((StrLen(Department_Felt02) >= 15) and (CopyStr(Department_Felt02, 1, 1) = 'ù')) then
                IF CopyStr(Department_Felt02, 1, 2) = 'ùC' THEN begin
                    Robert := copystr(Department_Felt02, 4, 20);
                    Department_Felt02 := CopyStr(Department_Felt02, 4, 16);
                end
                else begin
                    Robert := CopyStr(Department_Felt02, 2, 20);
                    Department_Felt02 := CopyStr(Department_Felt02, 2, 16);
                end
            else begin
                IF ((StrLen(Department_Felt02) > 15) and (CopyStr(Department_Felt02, 1, 1) = ']')) then begin
                    IF CopyStr(Department_Felt02, 1, 2) = ']C' THEN begin
                        Robert := copystr(Department_Felt02, 4, 20);
                        Department_Felt02 := CopyStr(Department_Felt02, 4, 16);
                    end
                    else begin
                        Robert := CopyStr(Department_Felt02, 2, 20);
                        Department_Felt02 := CopyStr(Department_Felt02, 2, 16);
                    end
                end
                else begin
                    IF StrLen(Department_Felt02) > 15 THEN begin
                        Robert := CopyStr(Department_Felt02, 1, 20);
                        Department_Felt02 := CopyStr(Department_Felt02, 1, 16);

                    end;
                end;
            end;

        end;

        if SalesItemNo = '' then begin
            IF StrLen(Department_Felt02) = 16 then
                Department_Felt02 := Robert;
            //SubStr(SalesLine.EANNr,1,StrLen(SalesLine.EANNr)-4)
        end;
        EanTemp := Department_Felt02;  //Så skal varenummer mv på linien og valideres mv



        //else begin  testing 121021
        EanItem02.Reset;
        EanItem02.SetRange(EANNr02, Department_Felt02);    //Rec.EANNr);

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
            Evaluate(QtyFelt03, Balance01_Felt03);
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
            EanItem.SetRange(EANNr, Department_Felt02);    //Rec.EANNr);

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
                Evaluate(QtyFelt03, Balance01_Felt03);
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
                EanItem.SetRange("No.", Department_Felt02);   //Rec.EANNr);
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
                    Evaluate(QtyFelt03, Balance01_Felt03);
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
        EanTemp := Department_Felt02;   //Rec.EANNr;
        EanItem.Reset;
        EanItem.SetRange(EANNr, Department_Felt02);     //Rec.EANNr);


        if EanItem.FindSet then
            SalesItemNo := EanItem."No."
        else begin

            EanItem.Reset;
            EanItem.SetRange(EANNr02, Department_Felt02);   //Rec.EANNr);
            if EanItem.FindSet then
                SalesItemNo := EanItem."No."

        end;

        if SalesItemNo = '' then begin
            if ((StrLen(Department_Felt02) >= 15) and (CopyStr(Department_Felt02, 1, 1) = 'ù')) then
                IF CopyStr(Department_Felt02, 1, 2) = 'ùC' THEN begin
                    Robert := copystr(Department_Felt02, 4, 20);
                    Department_Felt02 := CopyStr(Department_Felt02, 4, 16);
                end
                else begin
                    Robert := CopyStr(Department_Felt02, 2, 20);
                    Department_Felt02 := CopyStr(Department_Felt02, 2, 16);
                end
            else begin
                IF ((StrLen(Department_Felt02) > 15) and (CopyStr(Department_Felt02, 1, 1) = ']')) then begin
                    IF CopyStr(Department_Felt02, 1, 2) = ']C' THEN begin
                        Robert := copystr(Department_Felt02, 4, 20);
                        Department_Felt02 := CopyStr(Department_Felt02, 4, 16);
                    end
                    else begin
                        Robert := CopyStr(Department_Felt02, 2, 20);
                        Department_Felt02 := CopyStr(Department_Felt02, 2, 16);
                    end
                end
                else begin
                    IF StrLen(Department_Felt02) > 15 THEN begin
                        Robert := CopyStr(Department_Felt02, 1, 20);
                        Department_Felt02 := CopyStr(Department_Felt02, 1, 16);

                    end;
                end;
            end;

        end;

        if SalesItemNo = '' then begin
            IF StrLen(Department_Felt02) = 16 then
                Department_Felt02 := Robert;
            //SubStr(SalesLine.EANNr,1,StrLen(SalesLine.EANNr)-4)
        end;
        EanTemp := Department_Felt02;  //Så skal varenummer mv på linien og valideres mv



        //else begin  testing 121021
        EanItem02.Reset;
        EanItem02.SetRange(EANNr02, Department_Felt02);    //Rec.EANNr);

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
            Evaluate(QtyFelt03, Balance01_Felt03);
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
            EanItem.SetRange(EANNr, Department_Felt02);    //Rec.EANNr);

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
                Evaluate(QtyFelt03, Balance01_Felt03);
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
                EanItem.SetRange("No.", Department_Felt02);   //Rec.EANNr);
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
                    Evaluate(QtyFelt03, Balance01_Felt03);
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

}