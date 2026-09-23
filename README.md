# <img src="./assets/icon.svg" alt="" height="26"> BC Session Management

A lightweight Microsoft Dynamics 365 Business Central extension for monitoring active sessions, terminating sessions when necessary, and reviewing users' most recent sign-in and sign-off activity.

BC Session Management works entirely with standard Business Central session functionality and can be used with Business Central environments including on-premises installations.

## Features

### Active Session Management

The **Session Management** page provides an overview of currently active Business Central sessions.

It displays the most relevant session information, including:

- Session ID
- User ID
- Client type
- Login date and time

The currently active session is highlighted to make it easy to identify your own session.

### Detailed Session Information

The page provides an optional **Detailed Mode** that exposes additional technical information useful for troubleshooting and administration:

- Session Unique ID
- User SID
- Server Instance ID
- Server Instance Name
- Server Computer Name
- Client Computer Name
- Database Name

Use **Simple Mode** to return to the reduced day-to-day view.

### Terminate Active Sessions

Active sessions can be terminated directly from the Session Management page.

Before terminating a session, Business Central displays a confirmation dialog.

The currently logged-in user's own session cannot be terminated from the page, helping prevent an administrator from accidentally disconnecting themselves.

When a session is terminated, the affected session receives a message identifying the Business Central user who terminated it.

The extension uses the standard Business Central session API:

```al
Session.StopSession(SessionId, Comment)
```

### User Session Overview

The **User Session Overview** page displays Business Central users together with their latest recorded session activity.

The page includes:

- User Name
- Full Name
- User State
- Last Sign-in
- Last Sign-off

The sign-in and sign-off information is retrieved from the standard Business Central **Session Event** table.

For each user, BC Session Management determines the most recent:

- `Logon` event
- `Logoff` event

This provides a quick way to see when a user most recently accessed or left the Business Central environment.

## Pages

### Session Management

| Property | Value |
| --- | --- |
| Object ID | `50500` |
| Object Name | `PTE Session Management` |
| Caption | `Session Management` |
| Page Type | `List` |
| Source Table | `Active Session` |
| Usage Category | `Lists` |

The page can be found using Business Central's **Tell Me** search by searching for:

```text
Session Management
```

#### Simple Mode

Simple Mode displays the information most useful for regular administration:

- Session ID
- User ID
- Client Type
- Login Date/Time
- Session termination action

#### Detailed Mode

Detailed Mode additionally displays:

- Session Unique ID
- User SID
- Server Instance ID
- Server Instance Name
- Server Computer Name
- Client Computer Name
- Database Name

### User Session Overview

| Property | Value |
| --- | --- |
| Object ID | `50501` |
| Object Name | `PTE User Session Overview` |
| Caption | `User Session Overview` |
| Page Type | `List` |
| Source Table | `User` |
| Usage Category | `Administration` |

The page can be found using Business Central's **Tell Me** search by searching for:

```text
User Session Overview
```

## Session History

BC Session Management uses the standard Business Central **Session Event** table to determine a user's latest sign-in and sign-off.

For each user, session events are filtered by the user's security ID and event type.

The newest matching event is then retrieved using the `User SID` and `Event Datetime` key:

```al
SessionEvent.SetRange("User SID", Rec."User Security ID");
SessionEvent.SetRange("Event Type", SessionEvent."Event Type"::Logon);

SessionEvent.SetCurrentKey("User SID", "Event Datetime");

if SessionEvent.FindLast() then
    LastLogon := SessionEvent."Event Datetime";
```

The same process is used for `Logoff` events.

No custom tables are required.

## Standard Business Central Objects Used

The extension relies on standard Business Central functionality:

```text
Active Session
User
Session Event
Session.StopSession()
```

This keeps the extension lightweight and avoids maintaining a separate session-history database.

## Use Cases

BC Session Management can be useful for administrators, developers, consultants, and support teams who need to:

- See currently active Business Central sessions
- Identify which users are connected
- Identify the client type used by a session
- See when a session was started
- Inspect server and client information
- Identify the server instance handling a session
- Terminate stuck or unwanted sessions
- Check when a user last signed in
- Check when a user last signed off
- Troubleshoot session-related issues in SaaS or on-premises environments

## Installation

Download the [latest release](https://github.com/Florian-Noever/BC-Session-Management/releases/latest) from the project's **GitHub Releases** page.

Each release is provided as a `.zip` archive containing the compiled Business Central `.app` package.

1. Download the `.zip` file from the latest GitHub release.
2. Extract the archive.
3. Locate the included `.app` file.
4. Publish and install the `.app` file in your Business Central environment.

### Business Central Online

Upload the extracted `.app` file through the **Extension Management** page in Business Central.

Open **Extension Management**, choose **Manage → Upload Extension**, select the `.app` file, and follow the installation dialog.

### Business Central On-Premises

For Business Central on-premises, use the extracted `.app` file with the Business Central Administration Shell or your environment's normal extension deployment process.

The extension must be published, synchronized, and installed before it becomes available to users.

## Compatibility

The current `app.json` targets:

| Setting | Value |
| --- | --- |
| Application | `23.0.0.0` |
| Platform | `23.0.0.0` |
| Runtime | `11.0` |
| Target | `Cloud` |

Although the compilation target is `Cloud`, the extension does not rely on OnPrem-only functionality.

Using the Cloud compilation target ensures the project remains restricted to APIs that are also suitable for Business Central online.

## Permissions

Users need sufficient Business Central permissions to access the underlying standard objects and functionality used by the extension.

In particular, administrators using the extension need access to:

- Active session information
- User information
- Session event information
- Session termination functionality

Session termination should only be made available to trusted administrative or support users.

## Important Notes

Session information is provided by Business Central itself.

The availability of individual values can depend on the client type, deployment environment, and server configuration.

For example, **Client Computer Name** might not be available for every type of session.

The **Last Sign-in** and **Last Sign-off** values reflect the session events currently available in the Business Central database.

They are not maintained separately by this extension.

## Resources

Project repository:

https://github.com/Florian-Noever/BC-Session-Management

Issues and bug reports:

https://github.com/Florian-Noever/BC-Session-Management/issues

## Contributing

Contributions, improvements, and bug reports are welcome.

If you encounter a problem or have an idea for an improvement, open an issue in the GitHub repository.

When contributing code, please keep the extension focused on lightweight Business Central session administration and avoid introducing unnecessary dependencies.

## Disclaimer

BC Session Management is an independent open-source Business Central extension and is not affiliated with or endorsed by Microsoft.

Microsoft Dynamics 365 Business Central is a trademark of Microsoft Corporation.
