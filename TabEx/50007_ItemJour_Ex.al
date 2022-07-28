tableextension 50007 "ItemJour ITB" extends "Item Journal Line"
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
                //if type = Type::Item then begin


                //end;
            end;


        }

        field(50001; Mangde; Text[20])
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

        field(50002; QtyColli; Decimal)
        {
            Caption = 'AntalColli';
            trigger OnValidate()
            var
            //item: Record Item;
            begin

            end;


        }
    }

    fieldgroups
    {
        //addlast( DropDown; Mangde) { }
    }

    trigger OnBeforeInsert()
    var

    begin




    end;


    trigger OnBeforeModify()

    var

    begin




    end;


}