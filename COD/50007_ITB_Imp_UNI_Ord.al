codeunit 50007 "50007_ITB_Imp_Uni_Ord"
{

    trigger OnRun()
    begin
        //MESSAGE('igang');
        //Mydialog.Open('Agiv kørsel', Svar01);
        Svar01 := Dialog.StrMenu('FORTRYD,Term. Ordrer,Term. flyt,Term. Ind,Term. færdig,Term. optæl');

        case Svar01 of
            1:
                begin
                    //Message('VareGrp');
                    Message('AFBRUDT - IKKE UDFØRT !');
                    ;
                end;
            2:
                begin
                    //Message('LagKart');
                    Xmlport.Run(xmlport::"50001_Imp_Uni_Ord");

                end;
            3:
                begin
                    //Message('DebKart');
                    Xmlport.Run(xmlport::"50001_Imp_Uni_Ord");
                end;
            4:
                begin
                    //Message('DebKart');
                    Xmlport.Run(xmlport::"50001_Imp_Uni_Ord");
                end;

        end;

    end;

    var
        VirkBog: Record "Gen. Product Posting Group";
        TempHoved: Record "Config. Template Header";
        TempLinie: Record "Config. Template Line";
        TempLineUd: Record "Config. Template Line";
        Streng: Text[50];
        VirkBogD: Record "Gen. Business Posting Group";
        Bogop: Record "General Posting Setup";
        TempHeader: Record "Config. Template Header";
        TempLine: Record "Config. Template Line";
        TempHeaderNy: Record "Config. Template Header";
        TempLineNy: Record "Config. Template Line";
        JLine: Record "Item Journal Line";
        VirkBog2: Record "Inventory Posting Group";
        VirkBog3: Record "Inventory Posting Group";
        VareBog: Record "Inventory Posting Setup";
        VareBog2: Record "Inventory Posting Setup";
        pksize: Integer;
        pksizetext: Text[50];
        pksizecount: Integer;
        Teksten: Text[50];
        A: array[60] of Text[30];
        cust: Record Customer;
        FinKonto: Record "G/L Account";
        BogopKopi: Record "General Posting Setup";

        MyDialog: Dialog;

        Svar01: Option; //ImpLagKart,ImpDebKart,ImpMedarb,ImpVareGrp;
        DateT: Date;
        CurrencyExRate: Decimal;
        currency: Record "Currency Exchange Rate";
    //SIMPLY_IND: Codeunit "50003_ITB_IND_SIM";

}

