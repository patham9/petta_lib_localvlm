!(import! &self (library faiss_ffi lib_faiss))
!(import! &self (library lib_patrick))
!(import! &self (library lib_import))
!(git-import! "https://github.com/patham9/petta_lib_localvlm.git")
!(import_prolog_functions_from_file (library lib_localvlm.pl) (vlm_query vlm_embed))

(= (closest-atom $avs $queryvector)
   (atom-of (match-k 1 &avs $queryvector)))

!(new-atom-vectorspace &avs 4096)
!(for $sentence ("this is a test" "the cat is in the house")
      (let $vector (vlm_embed "http://192.168.1.129:2277" $sentence)
           (add-atom-vector &avs $sentence $vector)))

!(test (let $queryvector (vlm_embed "http://192.168.1.129:2277" "this is an experiment")
            (closest-atom &avs $queryvector))
       "this is a test")

!(sread (vlm_query "http://192.168.1.129:2276" 
                   "give me all scandinavian capitals, format is strict S-Expression, output nothing else: ((capital1 country1) ... (cityn countryn))" 300))
