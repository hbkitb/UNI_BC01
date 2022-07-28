tableextension 50009 "SalesInv Line ITB" extends "Sales Invoice Line"
{
    fields
    {
        field(50000; EANNr; Text[50])
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

        field(50001; QtyColli; Decimal)
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

        field(50002; Mangde; Text[20])
        {
            Caption = 'Mængde';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin


                //end;
            end;


        }

        field(50003; PantLineNo; Integer)
        {
            Caption = 'Pant LinieNr';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin


                //end;
            end;


        }

        field(50004; Scan; Boolean)
        {
            Caption = 'Scan';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin


                //end;
            end;


        }


    }

    trigger OnAfterInsert()

    var

    begin

    end;



    var


}