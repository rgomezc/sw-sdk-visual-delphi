unit IssueJsonRequest;

interface
uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.JSON,
  System.JSON.Builders,
  System.JSON.Writers,
  System.JSON.Readers,
  System.JSON.BSON,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, Vcl.StdCtrls, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Types,
  Vcl.ComCtrls, StampRequest, StampResponseV1,
  StampResponseV2, StampResponseV3, StampResponseV4, SWHTTPClient, IdHTTP;

  function IssueServiceJSON(URL, Token, Json, Version: String): String;

implementation

function IssueServiceJSON(URL, Token, Json, Version: String): String;
var
  HTTPClient: TSWHTTPClient;
  RequestBody: TStringStream;
  IsUTF8: Boolean;
begin
  HTTPClient := TSWHTTPClient.Create;
  try
    RequestBody := nil;
    try
      IsUTF8 := TEncoding.UTF8.GetString(TEncoding.UTF8.GetBytes(Json)) = Json;

      if not IsUTF8 then
        RequestBody := TStringStream.Create(UTF8ToWideString(Json), TEncoding.UTF8)
      else
        RequestBody := TStringStream.Create(Json, TEncoding.UTF8);

      HTTPClient.HTTP.Request.Accept := 'application/json';
      HTTPClient.HTTP.Request.ContentType := 'application/jsontoxml';
      HTTPClient.HTTP.Request.CustomHeaders.FoldLines := False;
      HTTPClient.HTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + Token);

      URL := URL + '/v3/cfdi33/issue/json/' + Version;

      try
        Result := HTTPClient.Post(URL, RequestBody);
      except
        on E: EIdHTTPProtocolException do
          Result := E.ErrorMessage;
        on E: Exception do
          Result := E.Message;
      end;

    finally
      RequestBody.Free;
    end;
  finally
    HTTPClient.Free;
  end;

end;

end.
