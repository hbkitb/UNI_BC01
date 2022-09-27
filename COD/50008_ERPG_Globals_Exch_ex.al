codeunit 50008 "GlobalsExchange"
{

    trigger OnRun()
    begin

    end;

    var
        Employee: Record Employee;
    //  Global_UsrLoc: Text[10];
    //  Global_Cust: Code[10];
    //  Global_Vend: Code[20];
    //  Global_Item: Code[20];


    procedure UsrLoc_Get(var global_UsrLoc: Code[10]);
    var


    begin
        Clear(Employee);
        Employee.Reset;
        Employee.SetRange("No.", UserId);
        if Employee.FindSet then
            global_UsrLoc := Employee.UsrLoc;
    end;

    procedure Cust_Get(VAR global_cust: Code[20]);
    var

    begin
        Clear(Employee);
        Employee.Reset;
        Employee.SetRange("No.", UserId);
        if Employee.FindSet then
            global_cust := Employee.UsrCust;


    end;

    procedure Vend_Get(VAR global_Vend: Code[20]);
    var


    begin
        Clear(Employee);
        Employee.Reset;
        Employee.SetRange("No.", UserId);
        if Employee.FindSet then
            global_Vend := Employee.UsrVend;

    end;

    //260822
    procedure Item_Get(VAR global_item: Code[20]);
    var


    begin
        Clear(Employee);
        Employee.Reset;
        Employee.SetRange("No.", UserId);
        if Employee.FindSet then
            global_item := Employee.UsrItem;
    end;

    procedure Cust_Save(VAR global_cust: Code[20]);
    var

    begin
        Clear(Employee);
        Employee.Reset;
        Employee.SetRange("No.", UserId);
        if Employee.FindSet then begin
            Employee.UsrCust := global_cust;
            Employee.Modify;
        end;


    end;

    procedure Vend_Save(VAR global_Vend: Code[20]);
    var


    begin
        Clear(Employee);
        Employee.Reset;
        Employee.SetRange("No.", UserId);
        if Employee.FindSet then begin
            Employee.UsrVend := global_Vend;
            Employee.Modify;
        end;

    end;

    //260822
    procedure Item_Save(VAR global_item: Code[20]);
    var


    begin
        Clear(Employee);
        Employee.Reset;
        Employee.SetRange("No.", UserId);
        if Employee.FindSet then begin
            Employee.UsrItem := global_item;
            Employee.Modify;
        end;
    end;



}
