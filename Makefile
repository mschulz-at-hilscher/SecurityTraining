CC ?= "gcc"

all: exploitme exploitme2

%: %.c
	$(CC) -I. -fno-stack-protector -no-pie -fomit-frame-pointer -o $@ $^

%-asan: %.c
	$(CC) -I. -fno-stack-protector -no-pie -fsanitize=address -static-libasan -O2 -fno-omit-frame-pointer -g -o $@ $^

%-asan.o: %.c
	$(CC) -I. -c -fno-stack-protector -no-pie -fsanitize=address -O1 -fno-omit-frame-pointer -g -o $@ $^

%-asan-ld: %-asan.o
	$(CC) -o $@ $^

clean:
	$(RM) exploitme exploitme-asan exploitme2 exploitme2-asan *.o

cov-build:
	cov-build --dir cov-int make
	tar cfvz SecurityTraining.tar.gz cov-int

sonarqube-build:
	build-wrapper-linux-x86-64 --out-dir sonarqube-out make
	sonar-scanner -Dsonar.cfamily.build-wrapper-output=sonarqube-out

sanitizer-build: exploitme-asan
