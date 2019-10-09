
(* This file is free software, copyright Simon Cruanes. See file "LICENSE" for more details. *)

type t = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

(** {2 Memory-map} *)

let map_file_descr ?pos ?(shared=false) fd len =
  Bigarray.array1_of_genarray @@
    Bigstring_compat.map_file fd ?pos Bigarray.char Bigarray.c_layout shared [|len|]

let with_map_file ?pos ?len ?(mode=0o644) ?(flags=[Open_rdonly]) ?shared name f =
  let ic = open_in_gen flags mode name in
  let len = match len with
    | None -> in_channel_length ic
    | Some n -> n
  in
  let a = map_file_descr ?pos ?shared (Unix.descr_of_in_channel ic) len in
  try
    let x = f a in
    close_in ic;
    x
  with e ->
    close_in ic;
    raise e
