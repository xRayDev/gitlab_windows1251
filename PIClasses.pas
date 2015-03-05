unit PIClasses;

interface

uses DB, DBClient, Variants, SysUtils;

type
  TRunMethod = function (stName: string; Params: array of Variant): Variant of object;

  //Версия
  TVersion = class(TObject)
  private
    { Private declarations }
  public
    { Public declarations }
    //Параметры объекта  - Нельзя менять порядок или удалять этих полей
    inID: longInt;         //ID
    stProduct: string;     //Наименование
    stType:    string;        //Тип
    stVersion: string;     //Версия
    stState:   string;       //Состояние
    inAccessLevel: byte;   //Уровень доступа
    inLockLevel:   byte;     //Уровень блокировки
    boDocument: Boolean;   //Признак объекта-документа
    boRevision: Boolean;   //Признак релиза

    // Эти функции могут быть использованы без предварительного AssignRunMethod,
    // но только на объектах полученных из клиента: PgiCheckMenuItem и процедуры
    // привязаные к пунктам меню. Нельзя менять порядок или удалять эти функции
    function GetAttributes: Variant; virtual;
    function GetLinkedObjects(stLinkName: string; boDirection, boFullParse, boGroupByProduct, boForTree  : boolean) : Variant; virtual;
    function GetLinkedObjectsAndFiles(stLinkName: string; boFullParse, boOnlyDocuments : boolean): Variant; virtual;
    function GetDocuments: Variant; virtual;
    function GetFiles(boParse: boolean) : Variant; virtual;
    function GetPrivileges: Variant; virtual;
    function GetEmployInProjects: Variant; virtual;
    function InsertObjectsFromCliboard(stLinkName, stDBName : string; boCheckOut : boolean) : boolean; virtual;
    function GetVersionList: Variant; virtual;
    function UpObject(Name: string): Variant; virtual;

    procedure RefreshData(_ID_Version : Integer);
    procedure UpAttrValue(stName: string; vaValue: Variant; boDel: boolean = false);
    procedure UpdateStateOnObject(stNewState: string);
    function NewVersion(stNewState: string; vaFileList: Variant; inGroup: integer = 1): integer;

    constructor FromEmpty;
    constructor FromRecord(DS : TDataSet);
    constructor FromIDVersion(_ID_Version : Integer);
  end;

//Назначение полученного из клиента указателя RunMethod переменной
//RunMethod в unite PIClasses. Требуется для возможности вызова
//методов СП из других юнитов, юнит должен иметь в секции uses
//ссылку на PIClasses
procedure AssignRunMethod(RM : TRunMethod);

var RunMethod : TRunMethod;

const
  //Уровень доступа к объекту
  alNoaccess=0;
  alReadOnly=1;
  alFullControl=2;
  alAdministration=3;
  //Уровень блокировки объекта
  llNoLock=0;
  llMyLock=1;
  llNonMyLock=2;

implementation

Const
  CRLF = chr(13)+chr(10);

procedure AssignRunMethod(RM : TRunMethod);
begin
  RunMethod := RM;
end;

function GetValue(DataSet : TDataSet; stFieldName : string; vaDefault : Variant) : Variant;
begin
  if (DataSet.Fields.FindField(stFieldName) <> nil) and (DataSet[stFieldName] <> null) then
    GetValue := DataSet[stFieldName]
  else
    GetValue := vaDefault;
end;

constructor TVersion.FromRecord(DS : TDataSet);
begin
  inherited Create;
  Self.stType        := GetValue(DS,'_TYPE',        '');
  Self.stProduct     := GetValue(DS,'_PRODUCT',     '');
  Self.stVersion     := GetValue(DS,'_VERSION',     '');
  Self.stState       := GetValue(DS,'_STATE',       '');
  Self.inAccessLevel := GetValue(DS,'_ACCESSLEVEL', 0);
  Self.inLockLevel   := GetValue(DS,'_LOCKED',      0);
  Self.boDocument    := GetValue(DS,'_DOCUMENT',    FALSE);
  Self.boRevision    := GetValue(DS,'_REVISION',    FALSE);
  Self.inID          := GetValue(DS,'_ID_VERSION',  0);
end;

constructor TVersion.FromEmpty;
begin
  inherited Create;
  Self.stType        := '';
  Self.stProduct     := '';
  Self.stVersion     := '';
  Self.stState       := '';
  Self.inAccessLevel := 0;
  Self.inLockLevel   := 0;
  Self.boDocument    := FALSE;
  Self.boRevision    := FALSE;
  Self.inID          := 0;
end;

constructor TVersion.FromIDVersion(_ID_Version : Integer);
var
  DS : TClientDataSet;
begin
  inherited Create;

  DS := TClientDataSet.Create(nil);
  try
    DS.Data := RunMethod('GetInfoAboutVersion', ['','','', _ID_Version, 15]);
    Self.stType        := GetValue(DS,'_TYPE',        '');
    Self.stProduct     := GetValue(DS,'_PRODUCT',     '');
    Self.stVersion     := GetValue(DS,'_VERSION',     '');
    Self.stState       := GetValue(DS,'_STATE',       '');
    Self.inAccessLevel := GetValue(DS,'_ACCESSLEVEL', 0);
    Self.inLockLevel   := GetValue(DS,'_LOCKED',      0);
    Self.boDocument    := GetValue(DS,'_DOCUMENT',    FALSE);
    Self.boRevision    := GetValue(DS,'_REVISION',    FALSE);
    Self.inID          := GetValue(DS,'_ID_VERSION',  0);
  except
    DS.Data := null;
  end;
  DS.Free;
end;

procedure TVersion.RefreshData(_ID_Version : Integer);
var
  DS : TClientDataSet;
begin
  DS := TClientDataSet.Create(nil);
  try
    DS.Data := RunMethod('GetInfoAboutVersion', ['','','',_ID_Version,15]);
    Self.stType        := GetValue(DS,'_TYPE',        '');
    Self.stProduct     := GetValue(DS,'_PRODUCT',     '');
    Self.stVersion     := GetValue(DS,'_VERSION',     '');
    Self.stState       := GetValue(DS,'_STATE',       '');
    Self.inAccessLevel := GetValue(DS,'_ACCESSLEVEL', 0);
    Self.inLockLevel   := GetValue(DS,'_LOCKED',      0);
    Self.boDocument    := GetValue(DS,'_DOCUMENT',    FALSE);
    Self.boRevision    := GetValue(DS,'_REVISION',    FALSE);
    Self.inID          := GetValue(DS,'_ID_VERSION',  0);
  except
    DS.Data := null;
  end;
  DS.Free;
end;

{*****************************************************************}
{***  Реализация виртуальных методов. Необходима для объектов  ***}
{***  созданых в плагине, для корректной работы требуется      ***}
{***  предварительное выполнение AssignRunMethod               ***}
{*****************************************************************}

function TVersion.GetVersionList: Variant;
begin
  Result := RunMethod('GetVersionList', [stType, stProduct]);
end;

function TVersion.GetAttributes: Variant;
begin
  Result := RunMethod('GetInfoAboutVersion', [stType, stProduct, stVersion, 0, 2])
end;

function TVersion.GetFiles(boParse: boolean): Variant;
begin
  Result := RunMethod('GetInfoAboutVersion', [stType, stProduct, stVersion, 0, 7])
end;

function TVersion.GetLinkedObjects(stLinkName: string; boDirection, boFullParse, boGroupByProduct, boForTree: boolean): Variant;
begin
  Result := RunMethod('GetLinkedObjects',
    [Self.stType, Self.stProduct, Self.stVersion,
     stLinkName, boDirection, boFullParse, boGroupByProduct, boForTree]);
end;

function TVersion.GetLinkedObjectsAndFiles(stLinkName: string; boFullParse, boOnlyDocuments: boolean): Variant;
begin
  Result := RunMethod('GetLinkedObjectsAndFiles',
    [Self.stType, Self.stProduct, Self.stVersion,
      stLinkName, boFullParse, boOnlyDocuments]);
end;

function TVersion.GetDocuments: Variant;
begin
end;

function TVersion.GetPrivileges: Variant;
begin
  Result := RunMethod('GetInfoAboutVersion', [stType, stProduct, stVersion, 0, 8])
end;

function TVersion.GetEmployInProjects: Variant;
begin
end;

function TVersion.UpObject(Name: string): Variant;
var
  stNewProduct: Variant;
begin
  stNewProduct := RunMethod('UpObject', [stType, stProduct, Name]);
  Result := not (VarIsClear(stNewProduct) or VarIsNull(stNewProduct));
  if Result then stProduct := stNewProduct;
end;

function TVersion.InsertObjectsFromCliboard(stLinkName, stDBName: string; boCheckOut: boolean): boolean;
begin
end;
{*****************************************************************}

procedure TVersion.UpAttrValue(stName: string; vaValue: Variant; boDel: boolean = false);
var
  boEmpty: boolean;
begin
  if boDel then boEmpty := true
  else boEmpty := VarIsNull(vaValue) or
                  VarIsClear(vaValue) or
                  VarIsEmpty(vaValue) or
                  (VarIsStr(vaValue) and (trim(vaValue)=''));
  RunMethod('UpAttrValue',[stType, stProduct, stVersion, stName, vaValue, '', boDel or boEmpty]);
end;

procedure TVersion.UpdateStateOnObject(stNewState: string);
begin
  RunMethod('UpdateStateOnObject',[stType, stProduct, stVersion, stNewState]);
end;

function TVersion.NewVersion(stNewState: string; vaFileList: Variant; inGroup: integer = 1): integer;
begin
  Result := RunMethod('NewVersion',
    [stType, stProduct, stVersion,
     stNewState, vaFileList, inGroup]);
end;

end.
