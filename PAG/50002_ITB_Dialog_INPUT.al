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

        Gloal_Var.TermOrd_Get(CustAccount, Antal, ItemTerm);
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
        Gloal_Var.TermOrd_Save(CustAccount, Antal, ItemTerm);
    end;

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