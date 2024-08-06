FROM ubuntu
RUN apt update
RUN apt -y install wget curl fzf
RUN mkdir -p /PLS_TEST_ENV/a/b/c
RUN mkdir -p /PLS_TEST_ENV/global
RUN mkdir -p /PLS_TEST_ENV/pls_dir
RUN mkdir -p /PLS_TEST_ENV/config
RUN curl -sS "https://raw.githubusercontent.com/codevogel/pls/main/release/pls" > /PLS_TEST_ENV/pls
RUN chmod +x ./PLS_TEST_ENV/pls
RUN curl -sS "https://raw.githubusercontent.com/codevogel/pls/main/spec/samples/valid/global_list.yml" > /PLS_TEST_ENV/global/pls_global.yml
RUN curl -sS "https://raw.githubusercontent.com/codevogel/pls/main/spec/samples/valid/local_list.yml" > /PLS_TEST_ENV/a/b/c/pls.yml
RUN curl -sS "https://raw.githubusercontent.com/codevogel/pls/main/docker/.plsrc" > /PLS_TEST_ENV/config/plsrc
RUN curl -sS "https://raw.githubusercontent.com/codevogel/pls/main/docker/welcome.txt" > /PLS_TEST_ENV/welcome.txt
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
RUN echo "export PATH=$PATH:/PLS_TEST_ENV/" >> ~/.bashrc
RUN echo "export PLS_RC=/PLS_TEST_ENV/config/plsrc" >> ~/.bashrc

WORKDIR /PLS_TEST_ENV/a/b/c

CMD ["/bin/bash", "-c", "cat /PLS_TEST_ENV/welcome.txt && exec /bin/bash"]

