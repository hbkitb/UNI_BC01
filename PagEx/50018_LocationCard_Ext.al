pageextension 50018 "ItemLocationCard_Ext" extends "Location Card"
{
    layout
    {

        addafter(Code)
        {

            field(AccountCash; Rec.AccountCash)
            {
                ApplicationArea = all;
                Caption = 'Kontant-Konto';
                //ToolTip = 'Angiv sti og filnavn til LEAN-faktura-fil';
                //Editable = false;

                trigger OnValidate()
                var

                begin


                end;
            }

            field(AccountDan; Rec.AccountDan)
            {
                ApplicationArea = all;
                Caption = 'Dankort-Konto';
                //ToolTip = 'Angiv sti og filnavn til LEAN-faktura-fil';
                //Editable = false;

                trigger OnValidate()
                var

                begin


                end;
            }

        }




    }


}

