tableextension 50011 "Employee ERPG" extends Employee
{
    fields
    {
        field(50000; UsrLoc; Code[10])
        {
            Caption = 'Bruger Lokation';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50001; UsrCust; Code[20])
        {
            Caption = 'Bruger Debitor';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50002; UsrVend; Code[20])
        {
            Caption = 'Bruger Kreditor';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50003; UsrItem; Code[20])
        {
            Caption = 'Bruger Vare';
            trigger OnValidate()
            var

            begin

            end;


        }


    }

    var

}