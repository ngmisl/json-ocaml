open Lwt
open Cohttp
open Cohttp_lwt_unix
open Format

let fetch_json url =
  Client.get (Uri.of_string url) >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Body of length: %d\n" (String.length body);
  body

let parse_json json =
  let open Yojson.Basic.Util in
  let json = Yojson.Basic.from_string json in
  (* Here you can access the fields of the JSON object *)
  (* For example, if the JSON object has a field "name", you can get it like this: *)
  let id = json |> member "id" |> to_string in
  let name = json |> member "name" |> to_string in
  let description = json |> member "description" |> to_string in
  let image = json |> member "image" |> to_string in
  printf "\n Id: %s\n Name: %s\n Desription: %s\n Image: %s\n" id name
    description image

let () =
  let json =
    Lwt_main.run
      (fetch_json
         "https://raw.githubusercontent.com/Not-Gonna-Make-It/items-json/main/1.json")
  in
  parse_json json
