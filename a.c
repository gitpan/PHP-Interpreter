           #include <EXTERN.h>
           #include <perl.h>

           static PerlInterpreter *my_perl;

           int main(int argc, char **argv, char **env)
           {
               char *args[] = { NULL };
               PERL_SYS_INIT3(&argc,&argv,&env);
               my_perl = perl_alloc();
               perl_construct(my_perl);
               eval_sv(newSVpv(argv[1], 0), G_SCALAR | G_EVAL | G_KEEPERR);

               perl_destruct(my_perl);
               perl_free(my_perl);
               PERL_SYS_TERM();
           }
