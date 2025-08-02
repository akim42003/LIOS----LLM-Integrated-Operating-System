# VM and Cross-Compiler Setup

## 1. VM Environment

* **Base OS**: Debian
* **Virtualization**: QEMU/KVM (with `virt-manager`) for BIOS & UEFI modes
* **Host‑side packages**:

  ```bash
  sudo apt-get update
  sudo apt-get install build-essential git flex bison libncurses5-dev \
                       python3-setuptools gdb qemu-system-x86
  ```

## 2. Directory Layout

All sources and out-of-tree builds live under `~/toolchain-src`:

```
~/toolchain-src/
├─ binutils-2.40/        # Binutils sources
├─ build-binutils/       # Binutils build directory
├─ gcc-13.2.0/           # GCC sources
└─ build-gcc/            # GCC out-of-tree build
```

## 3. Install Additional Prerequisites

```bash
sudo apt-get install libgmp-dev libmpfr-dev libmpc-dev libisl-dev texinfo
```

*(Needed by GCC’s `configure` to build GMP/MPFR/MPC dependencies)*

## 4. Build & Install Binutils

```bash
cd ~/toolchain-src
wget https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.xz
tar xf binutils-2.40.tar.xz
mkdir build-binutils && cd build-binutils
../binutils-2.40/configure \
  --target=i686-elf \
  --prefix="$HOME/opt/cross" \
  --disable-nls \
  --disable-werror
make -j$(nproc)
make install
```

## 5. Prepare & Build Stage‑1 GCC

1. **Download & bundle prerequisites**:

   ```bash
   cd ~/toolchain-src
   ```

tar xf gcc-13.2.0.tar.xz
cd gcc-13.2.0
e contrib/download\_prerequisites

````
2. **Configure & compile**:
   ```bash
   mkdir ../build-gcc && cd ../build-gcc
   ../gcc-13.2.0/configure \
     --target=i686-elf \
     --prefix="$HOME/opt/cross" \
     --disable-nls \
     --disable-shared \
     --enable-languages=c \
     --without-headers
   make all-gcc -j$(nproc)
   make install-gcc
````

## 6. Hook Toolchain into Your Shell

```bash
echo 'export PATH="$HOME/opt/cross/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Confirm with:

```bash
i686-elf-gcc --version
i686-elf-ld --version
```
