AS = nasm
AFLAGS = -f elf -g -Fdwarf
LN = ld
LFLAGS = -m elf_i386

SRC_DIR_16 = Calculadora16
SRC_DIR_32 = Calculadora32
OBJ_DIR_16 = obj16
OBJ_DIR_32 = obj32

SRC_FILES_16 = $(wildcard $(SRC_DIR_16)/*.asm)
OBJ_FILES_16 = $(patsubst $(SRC_DIR_16)/%.asm,$(OBJ_DIR_16)/%.o,$(SRC_FILES_16))

SRC_FILES_32 = $(wildcard $(SRC_DIR_32)/*.asm)
OBJ_FILES_32 = $(patsubst $(SRC_DIR_32)/%.asm,$(OBJ_DIR_32)/%.o,$(SRC_FILES_32))

PROGRAMS_16 = calculadora16
PROGRAMS_32 = calculadora32

.PHONY: all
all: setup $(PROGRAMS_16) $(PROGRAMS_32)

.PHONY: setup
setup:
	mkdir -p $(OBJ_DIR_16) $(OBJ_DIR_32)

calculadora16: $(OBJ_FILES_16)
	$(LN) -m elf_i386 $(LFLAGS) $^ -o $@

calculadora32: $(OBJ_FILES_32)
	$(LN) -m elf_i386 $(LFLAGS) $^ -o $@

$(OBJ_DIR_16)/%.o: $(SRC_DIR_16)/%.asm
	$(AS) $(AFLAGS) $< -o $@

$(OBJ_DIR_32)/%.o: $(SRC_DIR_32)/%.asm
	$(AS) $(AFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -rf $(OBJ_DIR_16)/*.o $(OBJ_DIR_32)/*.o $(PROGRAMS_16) $(PROGRAMS_32)