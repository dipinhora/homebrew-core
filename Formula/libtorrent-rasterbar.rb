class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_8/libtorrent-rasterbar-1.1.8.tar.gz"
  sha256 "6bbf8fd0430e27037b09a870c89cfc330ea41816102fe1d1d16cc7428df08d5d"
  revision 1

  bottle do
    cellar :any
    sha256 "da975aa7d88a1da2d1814bc25ef43fb6ab397a5fc46591b1040a6c50a24c0ada" => :mojave
    sha256 "550af800561a4d33c9fccba045091a39b64502016006e5f011d84f224c54e6d2" => :high_sierra
    sha256 "5b98de7c476ce4b102520af2bb28bcad1bb3f25bc2e250dee1d757c573321d5e" => :sierra
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "openssl"
  depends_on "python@2"

  def install
    ENV.cxx11

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-encryption
      --enable-python-binding
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-boost-python=boost_python27-mt
    ]

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
    libexec.install "examples"
  end

  test do
    system ENV.cxx, "-L#{lib}", "-ltorrent-rasterbar",
           "-I#{Formula["boost"].include}/boost",
           "-L#{Formula["boost"].lib}", "-lboost_system",
           libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
