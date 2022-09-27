table 50000 "Term_div"
{
    Caption = 'Indlæsning Div./ALT Terminaler';
    //DataCaptionFields = "No.";
    //LookupPageID = "Item Vendor Catalog";

    fields
    {

        field(1; GId; Guid)
        {
            Caption = 'Rownumber/guid';

        }
        field(2; A; Text[100])    //Account
        {
            Caption = 'A';
            //Type - A=Adresse,D=Debitor,O=Ordre,''/blank lig bærer
            //NotBlank = true;
            //TableRelation = Employee;
        }
        field(3; B; Text[100])    //Department
        {
            Caption = 'B';
            //NotBlank = true;
            //TableRelation = Employee;
        }

        field(4; C; Text[100])    //Center
        {
            Caption = 'C';
            //NotBlank = true;
            //TableRelation = Employee;
        }

        field(5; D; Text[100])    //Purpose
        {
            Caption = 'D';
            //NotBlank = true;
            //TableRelation = Employee;
        }
        field(6; E; Text[100])    //Balance01
        {
            Caption = 'E';
            //NotBlank = true;
            //TableRelation = Employee;
        }
        field(7; F; Text[100])    //Balance02
        {
            Caption = 'F';

        }
        field(8; G; Text[100])
        {
            Caption = 'G';

        }
        field(9; H; Text[100])
        {
            Caption = 'H';

        }

        field(10; Id; Integer)
        {
            AutoIncrement = true;
            Caption = 'Unik Id';

        }
        field(11; Used_; Text[5])
        {

            Caption = 'Used';

        }
        field(12; UserId_; Text[5])
        {

            Caption = 'UserId';

        }

    }

    keys
    {
        key(Key1; Id)  //sales ny - 070422
        {
            //Clustered = true;
        }

    }

    fieldgroups
    {
        /*
        fieldgroup(Dropdown; Employee, Account, OffSetAccount)
        {
        }
        */
    }

    trigger OnDelete()
    begin

    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
    //Cust: Record Customer;

}

