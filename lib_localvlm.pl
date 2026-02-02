:- use_module(library(http/http_client)).
:- use_module(library(http/json)).

%% --- low-level HTTP ---
vlm_post(Server, Query, MaxTokens, Raw) :- string_concat(Server, "/v1/chat/completions", URL),
                                           format(atom(JSON), '{ "messages": [ {"role": "user", "content": "~w"} ], "max_tokens": ~w }', [Query, MaxTokens]),
                                           http_post(URL, atom(JSON), Raw, [request_header('Content-Type'='application/json')]).
%% --- extraction only ---
vlm_extract_message(Raw, Content) :- atom_json_dict(Raw, Dict, []),
                                     Dict.choices = [Choice|_],
                                     Content = Choice.message.content.

%% --- convenience wrapper ---
vlm_query(Server, Query, MaxTokens, Ret) :- vlm_post(Server, Query, MaxTokens, Raw),
                                            vlm_extract_message(Raw, Ret).
%% --- low-level HTTP (embeddings) ---
embed_post(Server, Text, Raw) :- string_concat(Server, "/v1/embeddings", URL),
                                 format(atom(JSON), '{ "model": "Qwen3-Embedding-8B-Q8_0", "input": "~w" }', [Text]),
                                 http_post(URL, atom(JSON), Raw, [request_header('Content-Type'='application/json')]).

%% --- extraction only (vector as list of numbers) ---
embed_extract_vector(Raw, Vector) :- atom_json_dict(Raw, Dict, []),
                                     Dict.data = [Item|_],
                                     Vector = Item.embedding.

%% --- convenience wrapper ---
vlm_embed(Server, Text, Vector) :- embed_post(Server, Text, Raw),
                                   embed_extract_vector(Raw, Vector).
