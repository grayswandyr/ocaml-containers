
(*
copyright (c) 2013-2014, simon cruanes
all rights reserved.

redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.  redistributions in binary
form must reproduce the above copyright notice, this list of conditions and the
following disclaimer in the documentation and/or other materials provided with
the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*)

(** {1 Pretty-Printing of Boxes} *)

type position = { x:int ; y: int }
(** Positions are relative to the upper-left corner, that is,
when [x] increases we go toward the right, and when [y] increases
we go toward the bottom (same order as a printer) *)

val origin : position
(** Initial position *)

module Output : sig
  type t = {
    put_char : position -> char -> unit;
    put_string : position -> string -> unit;
    put_sub_string : position -> string -> int -> int -> unit;
    flush : unit -> unit;
  }

  (** {6 Default Instance: a buffer} *)

  type buffer

  val make_buffer : unit -> buffer * t
  (** New buffer, and the corresponding output (buffers are mutable) *)

  val buf_to_lines : ?indent:int -> buffer -> string
  (** Print the content of the buffer into a string.
      @param indent number of spaces to insert in front of the lines *)

  val buf_output : ?indent:int -> out_channel -> buffer -> unit
  (** Print the buffer on the given channel *)
end

module Box : sig
  type t

  val size : t -> position
  (** Size needed to print the box *)

  val line : string -> t
  (** Make a single-line box.
      @raise Invalid_argument if the string contains ['\n'] *)

  val text : string -> t
  (** Any text, possibly with several lines *)

  val lines : string list -> t
  (** Shortcut for {!text}, with a list of lines *)

  val frame : t -> t
  (** Put a single frame around the box *)

  val grid : ?framed:bool -> t array array -> t
  (** Grid of boxes (no frame between boxes). The matrix is indexed
      with lines first, then columns.
      @param framed if [true], each item of the grid will be framed.
        default value is [true] *)

  val init_grid : ?framed:bool ->
                  line:int -> col:int -> (line:int -> col:int -> t) -> t
  (** Same as {!grid} but takes the matrix as a function *)

  val vlist : ?framed:bool -> t list -> t
  (** Vertical list of boxes *)

  val hlist : ?framed:bool -> t list -> t
  (** Horizontal list of boxes *)
end

val render : Output.t -> Box.t -> unit

val to_string : Box.t -> string

val output : ?indent:int -> out_channel -> Box.t -> unit