pageextension 50015 "Company_Ext" extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {

            field(LEANInvPath; Rec.LEANInvPath)
            {
                ApplicationArea = all;
                Caption = 'LEAN-Fakt-Sti';
                ToolTip = 'Angiv sti og filnavn til LEAN-faktura-fil';

                trigger OnValidate()
                var

                begin


                end;
            }



        }


    }

}