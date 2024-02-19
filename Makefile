all: exploitme

%: %.c
	$(CC) -fno-stack-protector -no-pie -fomit-frame-pointer -o $@ $^
