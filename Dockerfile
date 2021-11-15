FROM elixir:1.10.3 

RUN mkdir /timemanager
COPY ./api /timemanager/
COPY ./start.sh /timemanager/
WORKDIR /timemanager
RUN mix local.hex --force
RUN mix deps.clean --all
RUN mix deps.get
RUN mix local.rebar --force

RUN chmod +x ./start.sh

CMD ["./start.sh"]