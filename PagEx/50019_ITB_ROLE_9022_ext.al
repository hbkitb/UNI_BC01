pageextension 50019 BusinessManagerRC extends "Business Manager Role Center"
{


    actions
    {
        addafter("Chart of Accounts")
        {
            action("Terminaler")
            {
                ApplicationArea = Basic, Suite;
                CaptionML = DAN = 'Indlæs terminaler', ENU = 'Indlæs terminaler';
                Image = Import;
                //Visible = InnotechDK;
                RunObject = codeunit "50007_ITB_Imp_Uni_Ord";
                ToolTip = 'Diverse import fra terminal';
            }



        }

    }




}