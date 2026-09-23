page 52501 "PTE User Session Overview"
{
    ApplicationArea = All;
    Caption = 'User Session Overview';
    Editable = false;
    PageType = List;
    SourceTable = User;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User Name"; Rec."User Name")
                {
                    Tooltip = '-';
                }
                field("Full Name"; Rec."Full Name")
                {
                    Tooltip = '-';
                }
                field(State; Rec.State)
                {
                    Tooltip = '-';
                }
                field("Last Logon"; LastLogon)
                {
                    Caption = 'Last Sign-in';
                    Tooltip = '-';
                }
                field("Last Logoff"; LastLogoff)
                {
                    Caption = 'Last Sign-off';
                    Tooltip = '-';
                }
            }
        }
    }

    var
        LastLogoff: DateTime;
        LastLogon: DateTime;

    trigger OnAfterGetRecord()
    begin
        CalcLastLogon();
        CalcLastLogoff();
    end;

    local procedure CalcLastLogon()
    var
        SessionEvent: Record "Session Event";
    begin
        Clear(LastLogon);

        SessionEvent.SetLoadFields("User SID", "Event Type", "Event Datetime");
        SessionEvent.SetRange("User SID", Rec."User Security ID");
        SessionEvent.SetRange("Event Type", SessionEvent."Event Type"::Logon);

        SessionEvent.SetCurrentKey("User SID", "Event Datetime");
        if SessionEvent.FindLast() then
            LastLogon := SessionEvent."Event Datetime";
    end;

    local procedure CalcLastLogoff()
    var
        SessionEvent: Record "Session Event";
    begin
        Clear(LastLogoff);

        SessionEvent.SetLoadFields("User SID", "Event Type", "Event Datetime");
        SessionEvent.SetRange("User SID", Rec."User Security ID");
        SessionEvent.SetRange("Event Type", SessionEvent."Event Type"::Logoff);

        SessionEvent.SetCurrentKey("User SID", "Event Datetime");
        if SessionEvent.FindLast() then
            LastLogoff := SessionEvent."Event Datetime";
    end;
}