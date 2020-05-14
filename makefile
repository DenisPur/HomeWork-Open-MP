FLAGS = -C -O2 -qopenmp
TM = task
CM = const
COMPILE = ifort

main: main.f90 $(TM).o $(CM).o
	$(COMPILE) $^ $(FLAGS) -o $@

$(TM).o: $(TM).f90 $(CM).o
	$(COMPILE) $^ $(FLAGS) -c 
$(CM).o: $(CM).f90
	$(COMPILE) $^ $(FLAGS) -c 

clear:
	rm -f *.o *.mod