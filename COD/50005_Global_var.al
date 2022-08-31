codeunit 50005 "Global_Var"
{

    SingleInstance = true;

    trigger OnRun()
    begin

    end;

    var
        Global_AC_Number: Code[20];
        Global_AC_Cash: Decimal;
        Global_Term_Cust: Text[20];
        Global_Term_OrdRef: Text[20];  //260822
        Global_Term_Item: Text[20];

    procedure Kvit_Save(VAR AC_Number: Code[20]; VAR AC_Cash: Decimal);
    var


    begin
        Global_AC_Cash := AC_Cash;
        Global_AC_Number := AC_Number;
    end;

    procedure Kvit_Get(VAR AC_Number: Code[20]; VAR AC_Cash: Decimal);
    var


    begin
        //Global_AC_Cash := AC_Cash;
        //Global_AC_Number := AC_Number;
        AC_Cash := Global_AC_Cash;
        AC_Number := Global_AC_Number;
        //AC_Cash2 := Global_AC_Cash;
        //Message(format(Global_AC_Cash));
        //Message(format(AC_Cash));
        //Message(format(AC_Cash2));
        //exit(AC_Cash2);

    end;

    //260822
    procedure TermOrd_Save(VAR Term_Cust: Text[20]; VAR Term_OrdRef: Text[20]; VAR Term_Item: Text[20]);
    var


    begin
        Global_Term_Cust := Term_Cust;
        Global_Term_OrdRef := Term_OrdRef;
        Global_Term_Item := Term_Item;
    end;

    procedure TermOrd_Get(VAR Term_Cust: Text[20]; VAR Term_OrdRef: Text[20]; VAR Term_Item: Text[20]);
    var


    begin
        //Global_AC_Cash := AC_Cash;
        //Global_AC_Number := AC_Number;
        Term_Cust := Global_Term_Cust;
        Term_OrdRef := Global_Term_OrdRef;
        Term_Item := Global_Term_Item;
        //AC_Cash2 := Global_AC_Cash;
        //Message(format(Global_AC_Cash));
        //Message(format(AC_Cash));
        //Message(format(AC_Cash2));
        //exit(AC_Cash2);

    end;

    //260822

}
