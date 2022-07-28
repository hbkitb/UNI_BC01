tableextension 50004 "Location ITB" extends Location
{
    fields
    {
        field(50000; AccountCash; Code[20])
        {
            Caption = 'KontantKonto';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50001; AccountDan; Code[20])
        {
            Caption = 'DankortKonto';
            trigger OnValidate()
            var

            begin

            end;


        }

    }

    var

}