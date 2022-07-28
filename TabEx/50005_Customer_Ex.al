tableextension 50005 "Customer ITB" extends Customer
{
    fields
    {
        field(50000; LEAN; Text[50])
        {
            Caption = 'LEAN-EAN';
            trigger OnValidate()
            var

            begin

            end;


        }

    }

    var

}