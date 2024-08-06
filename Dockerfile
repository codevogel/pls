FROM ubuntu
RUN apt update
RUN apt -y install wget curl fzf
RUN mkdir -p ./PLS_TEST_ENV/a/b/c
RUN mkdir -p ./PLS_TEST_ENV/global
RUN curl -sS "https://raw.githubusercontent.com/codevogel/pls/main/release/pls" > ./PLS_TEST_ENV/pls
RUN chmod +x ./PLS_TEST_ENV/pls
RUN curl -sS "https://raw.githubusercontent.com/codevogel/pls/main/spec/samples/valid/global_list.yml" > ./PLS_TEST_ENV/global/.pls_global.yml
RUN curl -sS "https://raw.githubusercontent.com/codevogel/pls/main/spec/samples/valid/local_list.yml" > ./PLS_TEST_ENV/a/b/c/.pls.yml
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
RUN echo "export PATH=$PATH:/PLS_TEST_ENV/" >> ~/.bashrc
RUN echo "export PLS_GLOBAL=/PLS_TEST_ENV/global/.pls_global.yml" >> ~/.bashrc
WORKDIR /PLS_TEST_ENV/a/b/c

CMD ["/bin/bash", "-c", "printf 'Thanks for trying PLS!\\nA global pls file is available in /PLS_TEST_ENV/global/.pls_global.yml\\nA local pls file is available in  /PLS_TEST_ENV/a/b/c/.pls.yml\\nRecommended things to try, in order:\\n\\t1. run \"pls -l\" to list all available commands.\\n\\t2. Run \"pls\" to pick and execute the command '\\''duplicate'\\''. You will be prompted to verify and run it.\\n\\t3. Run \"pls duplicate\" to run it again, and confirm that verification is no longer needed.\\n\\t4. cd .. and run \"pls -l\" to list all available commands again.\\n\\t   You should notice that the local commands are now gone, and the \"duplicate\" now refers to the global command.\\n\\t5. Run \"pls -a my_new_alias -c \\\"echo what an alias!\\\" -s h\" to add an alias to the 'here' context.\\n\\t   You should notice that a new .pls.yml has been created in the CWD.\\n\\t6. Explore more!\\n' && exec /bin/bash"]
