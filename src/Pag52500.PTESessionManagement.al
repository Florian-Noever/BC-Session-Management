page 52500 "PTE Session Management"
{
    AdditionalSearchTerms = 'Session Management';
    ApplicationArea = All;
    Caption = 'Session Management',
        Comment = 'de-DE=Sitzungsverwaltung';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Active Session";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Session Unique ID"; Rec."Session Unique ID")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows the globally unique identifier (GUID) of the session.',
                        Comment = 'de-DE=Zeigt den global eindeutigen Bezeichner (GUID) der Sitzung an.';
                    Visible = DetailedModeEnabled;
                }
                field("User SID"; Rec."User SID")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows the security identifier (SID) of the user that owns this session.',
                        Comment = 'de-DE=Zeigt die Sicherheitskennung (SID) des Benutzers an, dem diese Sitzung gehört.';
                    Visible = DetailedModeEnabled;
                }
                field("Session ID"; Rec."Session ID")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows the unique ID of the active session.',
                        Comment = 'de-DE=Zeigt die eindeutige ID der aktiven Sitzung an.';
                }
                field("Server Instance ID"; Rec."Server Instance ID")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows the internal ID of the Business Central server instance that the session is running on.',
                        Comment = 'de-DE=Zeigt die interne ID der Business-Central-Serverinstanz an, auf der die Sitzung ausgeführt wird.';
                    Visible = DetailedModeEnabled;
                }
                field("Server Instance Name"; Rec."Server Instance Name")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows the name of the Business Central server instance that the session is using.',
                        Comment = 'de-DE=Zeigt den Namen der Business-Central-Serverinstanz an, die von der Sitzung verwendet wird.';
                    Visible = DetailedModeEnabled;
                }
                field("Server Computer Name"; Rec."Server Computer Name")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows the name of the computer that is running the server instance.',
                        Comment = 'de-DE=Zeigt den Namen des Computers an, auf dem die Serverinstanz ausgeführt wird.';
                    Visible = DetailedModeEnabled;
                }
                field("User ID"; Rec."User ID")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows the user account that is logged on in this session.',
                        Comment = 'de-DE=Zeigt das Benutzerkonto an, das in dieser Sitzung angemeldet ist.';
                }
                field("Client Type"; Rec."Client Type")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows which client type the user is connected with, such as Web, Background, or SOAP.',
                        Comment = 'de-DE=Zeigt den Clienttyp an, mit dem der Benutzer verbunden ist, z. B. Web, Hintergrund oder SOAP.';
                }
                field("Client Computer Name"; Rec."Client Computer Name")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows the name of the client computer that the user connected from, if available.',
                        Comment = 'de-DE=Zeigt den Namen des Clientcomputers an, von dem sich der Benutzer verbunden hat, falls verfügbar.';
                    Visible = DetailedModeEnabled;
                }
                field("Login Datetime"; Rec."Login Datetime")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows the date and time when the user logged in to this session.',
                        Comment = 'de-DE=Zeigt Datum und Uhrzeit an, zu denen sich der Benutzer bei dieser Sitzung angemeldet hat.';
                }
                field("Database Name"; Rec."Database Name")
                {
                    Style = Strong;
                    StyleExpr = Rec."Session ID" = SessionId;
                    ToolTip = 'Shows the name of the database that the session is connected to.',
                        Comment = 'de-DE=Zeigt den Namen der Datenbank an, mit der die Sitzung verbunden ist.';
                    Visible = DetailedModeEnabled;
                }

                field("Kill Session"; 'KILL SESSION')
                {
                    Caption = 'Kill Session', Locked = true;
                    Enabled = Rec."Session ID" <> SessionId;
                    ToolTip = 'Click to terminate the selected active session.',
                        Comment = 'de-DE=Klicken Sie, um die ausgewählte aktive Sitzung zu beenden.';

                    trigger OnDrillDown()
                    var
                        KillSessionConfirmLbl: Label 'Are you sure you want to kill session with ID %1?',
                            Comment = 'de-DE=Möchten Sie die Sitzung mit der ID %1 wirklich beenden?';
                        SessionKilledLbl: Label 'Session with ID %1 has been killed.',
                            Comment = 'de-DE=Die Sitzung mit der ID %1 wurde beendet.';
                        SessionNotKilledErr: Label 'Could not kill session with ID %1.',
                            Comment = 'de-DE=Die Sitzung mit der ID %1 konnte nicht beendet werden.';
                        UserSessionKilledMsg: Label 'Session was killed by %1.',
                            Comment = 'de-DE=Die Sitzung wurde von %1 beendet.';
                    begin
                        if (Confirm(KillSessionConfirmLbl, false, Rec."Session ID")) then begin
                            if Session.StopSession(Rec."Session ID", StrSubstNo(UserSessionKilledMsg, USERID)) then
                                Message(SessionKilledLbl, Rec."Session ID")
                            else
                                Error(SessionNotKilledErr, Rec."Session ID");
                            CurrPage.Update();
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Simple Mode")
            {
                Caption = 'Simple Mode',
                    Comment = 'de-DE=Einfacher Modus';
                Enabled = DetailedModeEnabled;
                Image = Document;
                ToolTip = 'Switch to simple mode to see only the most important session information.',
                    Comment = 'de-DE=Wechseln Sie in den einfachen Modus, um nur die wichtigsten Sitzungsinformationen anzuzeigen.';

                trigger OnAction()
                begin
                    DetailedModeEnabled := false;
                end;
            }
            action("Detailed Mode")
            {
                Caption = 'Detailed Mode',
                    Comment = 'de-DE=Detail Modus';
                Enabled = not DetailedModeEnabled;
                Image = ViewDetails;
                ToolTip = 'Switch to detailed mode to see all session information.',
                    Comment = 'de-DE=Wechseln Sie in den detaillierten Modus, um alle Sitzungsinformationen anzuzeigen.';

                trigger OnAction()
                begin
                    DetailedModeEnabled := true;
                end;
            }
        }
        area(Promoted)
        {
            actionref(SimpleMode; "Simple Mode") { }
            actionref(DetailedMode; "Detailed Mode") { }
        }
    }

    var
        DetailedModeEnabled: Boolean;
        SessionId: Integer;

    trigger OnInit()
    begin
        SessionId := SessionId();
    end;
}