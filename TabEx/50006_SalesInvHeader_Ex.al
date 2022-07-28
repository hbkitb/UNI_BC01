tableextension 50006 "SalesINV Header ITB" extends "Sales Invoice Header"
{
    fields
    {
        field(50000; EANNr; Text[50])
        {
            Caption = 'EANNr';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50001; DagOrdre; Boolean)
        {
            Caption = 'DagOrdre';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50002; LEANOrdre; Integer)
        {
            Caption = 'LEANordre';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50003; DagFaktura; Boolean)
        {
            Caption = 'DagFaktura';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50004; Dankort; Boolean)
        {
            Caption = 'Dankort';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50005; LEANFakSend; Integer)
        {
            Caption = 'LEANFakSend';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50006; LEANFaktura; Integer)
        {
            Caption = 'LEANFakSend';
            trigger OnValidate()
            var

            begin

            end;


        }

        field(50007; LEANSendDag; Boolean)
        {
            Caption = 'LEANSendDag';
            trigger OnValidate()
            var

            begin

            end;


        }

    }

    var

}