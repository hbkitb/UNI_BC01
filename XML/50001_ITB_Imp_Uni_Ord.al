xmlport 50001 "50001_Imp_Uni_Ord"
{
    //Import af ekstra felter fra C5 Lagerkart

    Caption = 'Import Envina Kursus/ordre';
    DefaultFieldsValidation = false;
    Direction = Import;
    FieldDelimiter = '"';
    FieldSeparator = ';';
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

        if Lin1 = false then begin
            OrdKart.RESET;
            OrdKart.SetRange("No.", Account_Felt01);
            OrdKart.SetRange("Document Type", OrdKart."Document Type"::Order);
            if OrdKart.FindSet then begin  //opdater salgsordre


            end
            else begin // check for debitor og opret salgsordre på debitor
                DebKart.RESET;
                DebKart.SetRange("No.", Account_Felt01);
                if DebKart.FindSet then begin
                    FakKonto := DebKart."No.";
                end
                else begin
                    FakKonto := '99999999';
                end;
                // så oprettes salgsordre på fakkonto ->

            end;


            //250718 GenPostSetup.SETRANGE("Gen. Bus. Posting Group",Felt01);
            IF ((strlen(Account_Felt01) > 0) and (DebKart.FINDSET)) then begin //rediger eksisterende
                FakKonto := '';
                DebName := DebKart.Name;

                FakKonto := DebKart."Bill-to Customer No.";



                if FakKonto = '' then
                    FakKonto := Account_Felt01;
                //Message('fakkonto: ' + FakKonto);

                DebKart.Reset;
                DebKart.SetRange("No.", FakKonto);
                if DebKart.FindSet then begin
                    OrdNum := '';
                    OIOReference := '';
                    DebStd.Reset;
                    DebStd.SetRange("No.", Felt05);
                    if DebStd.FindSet then
                        OIOReference := DebStd."Fax No.";
                    if OIOReference = '' then
                        OIOReference := DebKart."Fax No.";
                    if OIOReference = '' then
                        OIOReference := Felt09;
                    OIOReference := DelChr(OIOReference, '<', ' ');
                    OIOReference := DelChr(OIOReference, '>', ' ');
                    //Message('gln: ' + OIOReference);
                    OrdKart.Reset;   //External doc er Reference
                    OrdKart.SetRange("Bill-to Customer No.", FakKonto);
                    if OIOReference <> '' then
                        OrdKart.SetRange("External Document No.", OIOReference)
                    else
                        OrdKart.SetRange("External Document No.", '.');
                    if OrdKart.FindSet then
                        OrdNum := OrdKart."No.";

                    LineNo := 0;
                    if OrdNum <> '' then begin
                        OrdLinie.Reset;
                        OrdLinie.SetRange("Document No.", OrdKart."No.");
                        if OrdLinie.FindSet then
                            repeat
                                if LineNo < OrdLinie."Line No." then
                                    LineNo := OrdLinie."Line No.";
                            until OrdLinie.Next = 0;
                        OrdNum := OrdKart."No.";
                        Number := OrdKart."No.";

                    end
                    else begin  //Så skal der oprettes en ny salgsordre-Hoved
                        OrdKart.Reset;
                        Clear(OrdKart);
                        OrdKart."Document Type" := OrdKart."Document Type"::Order;
                        //OrdKart.InitInsert;
                        //OrdKart.InitRecord;
                        //Message(OrdKart."No.");
                        //Message('ej ordkart: ' + DebKart."No.");
                        OrdKart.Validate(OrdKart."Sell-to Customer No.", DebKart."No.");
                        OrdKart.Validate(OrdKart."Bill-to Customer No.", DebKart."No.");

                        if OrdKart."VAT Registration No." = '' then
                            OrdKart."VAT Registration No." := '00000000';

                        if ((OrdKart."Bill-to Customer No." <> '') and (DebKart."VAT Registration No." <> '')) then
                            OrdKart."VAT Registration No." := DebKart."VAT Registration No.";

                        //EAN / GLN er på debitor

                        if Felt04 <> '' then
                            OrdKart."Sell-to E-Mail" := Felt04
                        else
                            OrdKart."Sell-to E-Mail" := DebKart."E-Mail";

                        OrdKart.Status := OrdKart.Status::Open;  //alternativt frigivet/released                        

                        OrdKart."Shipment Date" := Today;

                        //if FakKart."Fax No." <> '' then
                        OrdKart."Your Reference" := OIOReference;   //FakKart."Fax No.";
                                                                    //if FakKart."Fax No." <> '' then
                        OrdKart."External Document No." := OIOReference;   //FakKart."Fax No.";

                        if OIOReference = '' then begin
                            OrdKart."Your Reference" := Account_Felt01;
                            OrdKart."External Document No." := Account_Felt01;
                        end;

                        if OIOReference = '' then
                            OrdKart."External Document No." := '.';

                        if OrdKart."Sell-to Contact" = '' then
                            OrdKart."Sell-to Contact" := Department_Felt02 + '.';

                        OrdKart."OIOUBL-GLN" := DebKart.GLN;

                        OrdKart.Insert(true);
                        //Message('efter insert ok: ' + OrdKart."No.");
                        Number := OrdKart."No.";


                    end;

                end;

                //Så kommer ordrelinie(r) - A og B medlemmer

                //hertil Envina



                //if (AMedlem = true) and (btoA = true) then begin


                //Så kommer ordrelinier->
                Clear(OrdLinie);
                OrdLinie.validate(OrdLinie."Document Type", OrdKart."Document Type");
                OrdLinie.Validate(OrdLinie."Document No.", OrdKart."No.");
                LineNo := LineNo + 10000;
                OrdLinie."Line No." := LineNo + 10000;

                OrdLinie."Shipment Date" := OrdKart."Shipment Date";
                OrdLinie.Type := OrdLinie.Type::Item;
                //OrdLinie.Validate(Type);
                //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;

                if Item.Get(Felt20) then
                    OrdLinie.Validate("No.", Item."No.")
                else
                    Message('Ordre: ' + ordkart."No." + ' - fejl i varenummer');

                if Felt08 <> '' then
                    OrdLinie.Description := Felt08
                else
                    OrdLinie.Description := Item.Description;
                OrdLinie."Description 2" := Felt05 + ': ' + DebName;

                OrdLinie.Validate(quantity, 1);

                if AMedlem = true then begin
                    //OrdLinie."Unit Price" := 
                    Evaluate(OrdLinie."Unit Price", Felt17)
                end
                else begin
                    Evaluate(OrdLinie."Unit Price", Felt18)
                end;
                OrdLinie.Validate("Unit Price");


                OrdLinie.Validate(ordlinie.Amount, (OrdLinie."Unit Price" * OrdLinie.Quantity));
                OrdLinie.Validate(OrdLinie."Line Amount", OrdLinie.Quantity * OrdLinie."Unit Price");
                OrdLinie."Line Amount" := Round(OrdLinie."Line Amount", 0.01, '=');

                OrdLinie."Shipment Date" := OrdKart."Shipment Date";
                OrdLinie."Unit of Measure" := Item."Sales Unit of Measure";
                OrdLinie."Qty. to Invoice" := OrdLinie.Quantity;
                OrdLinie."Qty. to Ship" := OrdLinie.Quantity;
                OrdLinie."Qty. to Invoice (Base)" := OrdLinie.Quantity;
                OrdLinie."Qty. to Ship (Base)" := OrdLinie.Quantity;
                OrdLinie."Unit Cost" := Item."Unit Cost";

                OrdLinie.Insert(true);

                //Så kommer dimensioner
                if StrLen(Felt21) > 0 then begin
                    Centre.Reset;
                    Centre.SetRange("Dimension Code", 'BÆRER');
                    Centre.SetRange(Code, Felt21);
                    if Centre.FindSet then begin

                        DimMgt.GetDimensionSet(TempDimSetEntry, OrdLinie."Dimension Set ID");
                        TempDimSetEntry.Init;
                        TempDimSetEntry.Validate("Dimension Code", 'BÆRER');
                        TempDimSetEntry.Validate("Dimension Value Code", Centre.Code);
                        if not TempDimSetEntry.Insert then
                            TempDimSetEntry.Modify;
                        OrdLinie.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));
                        OrdLinie.Modify;
                    end;
                end;
                if AMedlem = false then begin
                    Purpose.Reset;
                    Purpose.SetRange("Dimension Code", 'FORMÅL');
                    if AMedlem = true then
                        Purpose.SetRange(Code, '')
                    else
                        Purpose.SetRange(Code, '02');

                    if Purpose.FindSet then begin //OR Amedlem = True then begin


                        DimMgt.GetDimensionSet(TempDimSetEntry, OrdLinie."Dimension Set ID");
                        TempDimSetEntry.Init;
                        TempDimSetEntry.Validate("Dimension Code", 'FORMÅL');
                        if AMedlem = false then
                            TempDimSetEntry.Validate("Dimension Value Code", Purpose.Code)
                        else
                            TempDimSetEntry.Validate("Dimension Value Code", '');
                        if not TempDimSetEntry.Insert then
                            TempDimSetEntry.Modify;
                        OrdLinie.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));

                        if OrdLinie."Dimension Set ID" = 0 then
                            OrdLinie."Dimension Set ID" := OrdKart."Dimension Set ID";

                        OrdLinie.Modify;


                    end;
                end;  //amedlem
                      //Så kommer evt. bemærkning/note til linien                               



                //071021
                if DebName <> '' then begin
                    Clear(OrdLinie);
                    OrdLinie.validate(OrdLinie."Document Type", OrdKart."Document Type");
                    OrdLinie.Validate(OrdLinie."Document No.", OrdKart."No.");
                    LineNo := LineNo + 10000;
                    OrdLinie."Line No." := LineNo + 10000;

                    OrdLinie."Shipment Date" := OrdKart."Shipment Date";
                    OrdLinie.Type := OrdLinie.Type::"G/L Account";
                    OrdLinie."No." := '002010';
                    OrdLinie."Unit of Measure" := 'STK';
                    //OrdLinie.Validate(Type);
                    //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;


                    OrdLinie.Description := Felt05 + ': ' + DebName;

                    //OrdLinie.Validate(quantity, 1);


                    OrdLinie.Insert(true);
                end;  //debitor navn og konto


                //Så kommer evt. overnatning
                if Felt16 <> '' then begin
                    Clear(OrdLinie);
                    OrdLinie.validate(OrdLinie."Document Type", OrdKart."Document Type");
                    OrdLinie.Validate(OrdLinie."Document No.", OrdKart."No.");
                    LineNo := LineNo + 10000;
                    OrdLinie."Line No." := LineNo + 10000;

                    OrdLinie."Shipment Date" := OrdKart."Shipment Date";
                    OrdLinie.Type := OrdLinie.Type::Item;
                    //OrdLinie.Validate(Type);
                    //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;

                    if Item.Get('3010') then
                        OrdLinie.Validate("No.", Item."No.")
                    else
                        Message('Ordre: ' + ordkart."No." + ' - fejl i varenummer');

                    if Item.Description <> '' then
                        OrdLinie.Description := Item.Description
                    else
                        OrdLinie.Description := 'Overnatning';

                    OrdLinie.Validate(quantity, -1);

                    //if AMedlem = true then begin
                    //OrdLinie."Unit Price" := 
                    //    Evaluate(OrdLinie."Unit Price", Felt17)
                    //end
                    //else begin
                    Evaluate(OrdLinie."Unit Price", Felt19);
                    //end;
                    OrdLinie.Validate("Unit Price");


                    OrdLinie.Validate(ordlinie.Amount, (OrdLinie."Unit Price" * OrdLinie.Quantity));
                    OrdLinie.Validate(OrdLinie."Line Amount", OrdLinie.Quantity * OrdLinie."Unit Price");
                    OrdLinie."Line Amount" := Round(OrdLinie."Line Amount", 0.01, '=');

                    OrdLinie."Shipment Date" := OrdKart."Shipment Date";
                    OrdLinie."Unit of Measure" := Item."Sales Unit of Measure";
                    OrdLinie."Qty. to Invoice" := OrdLinie.Quantity;
                    OrdLinie."Qty. to Ship" := OrdLinie.Quantity;
                    OrdLinie."Qty. to Invoice (Base)" := OrdLinie.Quantity;
                    OrdLinie."Qty. to Ship (Base)" := OrdLinie.Quantity;
                    OrdLinie."Unit Cost" := Item."Unit Cost";

                    OrdLinie.Insert(true);

                    //Så kommer dimensioner
                    if StrLen(Felt21) > 0 then begin
                        Centre.Reset;
                        Centre.SetRange("Dimension Code", 'BÆRER');
                        Centre.SetRange(Code, Felt21);
                        if Centre.FindSet then begin

                            DimMgt.GetDimensionSet(TempDimSetEntry, OrdLinie."Dimension Set ID");
                            TempDimSetEntry.Init;
                            TempDimSetEntry.Validate("Dimension Code", 'BÆRER');
                            TempDimSetEntry.Validate("Dimension Value Code", Centre.Code);
                            if not TempDimSetEntry.Insert then
                                TempDimSetEntry.Modify;
                            OrdLinie.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));
                            OrdLinie.Modify;
                        end;
                    end;

                    if AMedlem = false then begin
                        Purpose.Reset;
                        Purpose.SetRange("Dimension Code", 'FORMÅL');
                        if AMedlem = true then
                            Purpose.SetRange(Code, '')
                        else
                            Purpose.SetRange(Code, '02');

                        if Purpose.FindSet OR Amedlem = True then begin


                            DimMgt.GetDimensionSet(TempDimSetEntry, OrdLinie."Dimension Set ID");
                            TempDimSetEntry.Init;
                            TempDimSetEntry.Validate("Dimension Code", 'FORMÅL');
                            if AMedlem = false then
                                TempDimSetEntry.Validate("Dimension Value Code", Purpose.Code)
                            else
                                TempDimSetEntry.Validate("Dimension Value Code", '');
                            if not TempDimSetEntry.Insert then
                                TempDimSetEntry.Modify;
                            OrdLinie.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));

                            if OrdLinie."Dimension Set ID" = 0 then
                                OrdLinie."Dimension Set ID" := OrdKart."Dimension Set ID";

                            OrdLinie.Modify;


                        end;
                    end;  //purpose                    
                end;
                //Det var evt. overnatning

                //end
                //else
                //    Message('Medlem: ' + Felt05 + ' eksisterer ikke');
                //end;  //fakkart
            end; // opret salgsordre når fra B til A medlem

            //150921 until DebKart.NEXT = 0




            // end;
            //Her over ompostering vedr. B-Medlemmer
        end;

        //end;
        Lin1 := false;
    end;


}
