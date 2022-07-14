; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "DTOcean Data"
#define MyAppNameSafe "dtocean-data"
#define MyAppVersion "2022.07"
#define MyAppPublisher "DTOcean"
#define MyAppURL "https://github.com/DTOcean"
#define BinPath "bin"
#define SharePath "share"
#define IniDirName "DTOcean Hydrodynamics"
#define IniFileName "install.ini"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{54C4421C-EB34-4D00-A9F3-B37593213A75}
AppName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppVersion={#MyAppVersion}
Compression=lzma
DefaultDirName={sd}\{#MyAppPublisher}
DefaultGroupName={#MyAppName}
DisableDirPage=no
DisableProgramGroupPage=yes
OutputBaseFilename={#MyAppNameSafe}-{#MyAppVersion}
OutputDir=dist
PrivilegesRequired=lowest
SolidCompression=yes
UninstallFilesDir={commonappdata}\{#MyAppPublisher}\{#MyAppName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "{#BinPath}\*"; DestDir: "{app}\{#BinPath}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#SharePath}\*"; DestDir: "{app}\{#SharePath}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#IniFileName}"; DestDir: "{commonappdata}\{#MyAppPublisher}\{#MyAppName}"; DestName: "{#IniFileName}"; Permissions: users-modify
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[INI]
Filename: "{commonappdata}\{#MyAppPublisher}\{#MyAppName}\{#IniFileName}"; Section: "global"; Key: "prefix"; String: "{app}";
Filename: "{commonappdata}\{#MyAppPublisher}\{#MyAppName}\{#IniFileName}"; Section: "global"; Key: "bin_path"; String: "{#BinPath}";

[Code]
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;

function UninstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;

  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART', '', SW_HIDE, ewWaitUntilTerminated, iResultCode) then begin
      Result := 3;
    end else begin
      Result := 2;
    end;
  end else begin
    Result := 1;
  end;
end;

procedure WaitNotUpgrade;
var
  nRepeats: integer;
begin
  repeat
    Sleep(1000);
    nRepeats := nRepeats + 1;
  until (not IsUpgrade()) or (nRepeats > 100);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then begin
    if (IsUpgrade()) then begin
      WizardForm.FilenameLabel.Caption := 'Removing existing data..';
      UninstallOldVersion;
      WaitNotUpgrade;
    end;
  end; 
end; 
