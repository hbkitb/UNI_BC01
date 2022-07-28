pageextension 50017 "ItemJour_Ext" extends "Item Journal"
{
    layout
    {

        addafter("Posting Date")
        {

            field(EANNr; Rec.EANNr)
            {
                ApplicationArea = all;
                Caption = 'EanNr';
                //ToolTip = 'Angiv sti og filnavn til LEAN-faktura-fil';
                //Editable = false;

                trigger OnValidate()
                var

                begin


                end;
            }
        }
        addafter("Item No.")
        {

            field(QtyColli; Rec.QtyColli)
            {
                ApplicationArea = all;
                Caption = 'AntalKolli';
                //ToolTip = 'Angiv sti og filnavn til LEAN-faktura-fil';
                //Editable = false;

                trigger OnValidate()
                var

                begin


                end;
            }
        }

        addafter(Quantity)
        {

            field(Mangde; Rec.Mangde)
            {
                ApplicationArea = all;
                Caption = 'Mængde';
                //ToolTip = 'Angiv sti og filnavn til LEAN-faktura-fil';
                Editable = false;

                trigger OnValidate()
                var

                begin


                end;
            }



        }


    }

}