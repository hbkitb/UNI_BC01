pageextension 50020 "EmployeeCard_Ext" extends "Employee Card"
{
    layout
    {
        addafter("Salespers./Purch. Code")
        {

            field(UsrLoc; Rec.UsrLoc)
            {
                ApplicationArea = all;
                Caption = 'UsrLoc';
                ToolTip = 'Bruger lokation';

                trigger OnValidate()
                var

                begin


                end;
            }



        }


    }

}