tableextension 50008 "PurchINV Line ITB" extends "Purch. Inv. Line"
{
    fields
    {
        field(50000; QtyColli; Decimal)
        {
            Caption = 'AntalColli';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                if type = Type::Item then begin


                end;
            end;


        }

        field(50001; EANNr; Text[50])
        {
            Caption = 'EANNr';
            trigger OnValidate()
            var
                item: Record Item;


            begin
                if type = Type::Item then begin


                end;
            end;


        }

        field(50002; Scan; Boolean)
        {
            Caption = 'Scan';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                if type = Type::Item then begin


                end;
            end;


        }

    }



    var



}