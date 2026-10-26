# HCMUT Specialized Project Report Template

Template LaTeX cho báo cáo Đồ án chuyên ngành, đã map theo mục lục yêu cầu.

## Cách compile

Cùng một bộ nguồn `main.tex`, `Preamble/`, `Sections/`, `References/` và `Images/` dùng cho cả Windows lẫn Ubuntu. Không cần thay đổi nội dung LaTeX khi chuyển hệ điều hành. Cả hai cách build đều dùng XeLaTeX và Biber:

| Hệ điều hành | Kiểm tra công cụ | Build | File trung gian |
|---|---|---|---|
| Windows (PowerShell) | `.\build.ps1 -Check` | `.\build.ps1` | `.build/windows/` |
| Ubuntu (Bash) | `bash build.sh --check` | `bash build.sh` | `.build/ubuntu/` |

Cả hai xuất bản thành công ra `main.pdf` tại thư mục gốc. File trung gian được tách theo hệ điều hành và được Git bỏ qua để tránh dùng nhầm dữ liệu Biber/TeX cũ khi chuyển máy. Windows giữ chu trình XeLaTeX → Biber → XeLaTeX → XeLaTeX; Ubuntu dùng `latexmk` điều phối cùng các công cụ này.

### Chạy trên Windows

Báo cáo dùng **XeLaTeX** để biên dịch tiếng Việt và **Biber** để xử lý tài liệu tham khảo. Cài một trong hai bộ phân phối LaTeX dưới đây; mỗi bộ cung cấp compiler và trình quản lý thư viện.

#### 1. Tải compiler và thư viện

**Cách A — MiKTeX:**

1. Tải bộ cài Windows từ [trang tải MiKTeX chính thức](https://miktex.org/download), chạy bộ cài và hoàn tất cài đặt.
2. Mở **MiKTeX Console → Updates**, kiểm tra và cài các bản cập nhật.
3. Trong **Settings → General**, đặt **Install missing packages on-the-fly** thành **Always** để tự tải thư viện thiếu khi build. Cần kết nối Internet trong lần build đầu.
4. Trong mục **Packages**, tìm và cài `biber` nếu máy chưa có. Khi gặp thông báo thiếu file `.sty`, có thể tìm tên file/package trong mục này để cài thủ công.
5. Đóng và mở lại PowerShell sau khi cài để cập nhật `PATH`.

Tham khảo [hướng dẫn cài MiKTeX](https://miktex.org/howto/install-miktex) và [quản lý thư viện bằng MiKTeX Console](https://miktex.org/howto/miktex-console).

**Cách B — TeX Live:**

1. Tải `install-tl-windows.exe` từ [trang cài TeX Live chính thức](https://www.tug.org/texlive/acquire-netinstall.html).
2. Chạy bộ cài, chọn bộ **full** để cài compiler và các thư viện phục vụ báo cáo. Quá trình tải có thể lâu; cần đủ dung lượng đĩa và kết nối Internet.
3. Cài xong, mở lại PowerShell. Dùng **TeX Live Manager** khi cần cài thêm hoặc cập nhật package.

TeX Live trên Windows có kèm Perl tối thiểu; hướng dẫn chi tiết tại [TeX Live trên Windows](https://tug.org/texlive/windows.html).

Các thư viện được khai báo trong `Preamble/packages.tex` và `Preamble/bibliography.tex`, gồm `fontspec`, `babel` hỗ trợ tiếng Việt, `biblatex`, `biblatex-ieee`, `tikz`, `pgfplots`, `tcolorbox` và các thư viện bảng. MiKTeX có thể tải các package thiếu tự động; TeX Live bản full cung cấp sẵn các package tương ứng. Không cần tải thủ công từng file `.sty` vào dự án.

#### 2. Kiểm tra compiler

Mở PowerShell và chạy:

```powershell
xelatex --version
biber --version
.\build.ps1 -Check
```

Nếu báo không nhận diện lệnh, kiểm tra thư mục chứa `xelatex.exe` và `biber.exe` đã nằm trong biến môi trường `PATH`, sau đó mở lại Terminal. Nếu cài cả MiKTeX lẫn TeX Live, kiểm tra đường dẫn đang được sử dụng để tránh trộn hai môi trường:

```powershell
Get-Command xelatex, biber | Select-Object Name, Source
```

#### 3. Build và mở PDF

Mở PowerShell tại thư mục dự án chứa `main.tex` và `build.ps1`, chạy:

```powershell
.\build.ps1
```

Script chạy **XeLaTeX → Biber → XeLaTeX → XeLaTeX**, lưu file trung gian trong `.build/windows/`, chỉ cập nhật `main.pdf` tại thư mục gốc sau khi hoàn tất và không cần `latexmk` hoặc Perl. Sau mỗi lần sửa nội dung, chạy lại lệnh trên.

Nếu PowerShell chặn script, cho phép script cục bộ trong riêng cửa sổ PowerShell hiện tại rồi chạy lại:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
.\build.ps1
```

Mở kết quả:

```powershell
Start-Process .\main.pdf
```

Nếu chọn build bằng `latexmk`, chạy:

```powershell
latexmk -xelatex -halt-on-error -file-line-error -outdir=.build/windows main.tex
```

Lệnh `latexmk` trực tiếp xuất PDF vào `.build/windows/main.pdf`; script `build.ps1` tự sao chép kết quả về thư mục gốc.

Với MiKTeX, nếu `latexmk` báo thiếu Perl, có thể dùng `build.ps1` ở trên hoặc cài Perl trước khi dùng `latexmk`. TeX Live trên Windows đã kèm Perl tối thiểu.

#### 4. Xử lý lỗi thường gặp

Để xóa file trung gian Windows và build lại (giữ bản PDF tại thư mục gốc):

```powershell
.\build.ps1 -Clean
.\build.ps1
```

- **Thiếu package/file `.sty`:** bật tự cài package trong MiKTeX Console hoặc cài package qua trình quản lý thư viện của bộ phân phối đang dùng.
- **Biber không tương thích `biblatex`:** cập nhật Biber và các package LaTeX trong cùng bộ phân phối; kiểm tra lại `PATH`.
- **Không ghi được PDF:** đóng trình xem đang khóa `main.pdf` rồi build lại.
- **Lỗi nội dung LaTeX:** xem thông báo trong PowerShell và file `.build/windows/main.log`; lỗi tài liệu tham khảo có thêm trong `.build/windows/main.blg`.

Các ảnh PNG đã có sẵn nên build báo cáo không cần Python, Node.js hoặc Mermaid. VS Code và extension LaTeX Workshop là tùy chọn; chúng không thay thế compiler XeLaTeX và Biber.

### Chạy trên Ubuntu

Mở Terminal tại thư mục `DACN-Report` chứa `main.tex` và `build.sh`. Thực hiện các bước sau; chỉ cần cài công cụ ở bước 1 trong lần đầu.

#### 1. Cài công cụ

Báo cáo dùng **XeLaTeX + Biber** để xử lý Unicode tiếng Việt và tài liệu tham khảo. Cài các gói từ kho Ubuntu:

```bash
sudo apt update
sudo apt install latexmk biber texlive-xetex texlive-latex-extra texlive-science texlive-lang-other texlive-bibtex-extra texlive-fonts-recommended lmodern
```

#### 2. Kiểm tra và build PDF

Tại thư mục dự án, chạy bằng tài khoản người dùng thông thường:

```bash
bash build.sh --check
bash build.sh
```

Sau mỗi lần sửa nội dung `.tex`, chạy lại `bash build.sh` để cập nhật PDF. Không cần `sudo` hoặc cấp quyền thực thi khi gọi script bằng `bash`.

Kết quả là `main.pdf` tại thư mục gốc. `latexmk` tự chạy XeLaTeX và Biber đủ số lần để cập nhật mục lục, danh mục hình và trích dẫn. Các file trung gian và log nằm trong `.build/ubuntu/`. Script dùng đường dẫn của chính nó nên cũng chạy được khi gọi từ thư mục khác, kể cả đường dẫn có dấu cách. Nếu build lỗi, script dừng và giữ bản PDF đã xuất thành công trước đó.

#### 3. Mở PDF

Mở `main.pdf` bằng trình xem PDF hoặc chạy lệnh sau trên Ubuntu Desktop:

```bash
xdg-open main.pdf
```

#### 4. Dọn file tạm và xử lý lỗi

Để dọn file build trung gian, giữ bản PDF tại thư mục gốc:

```bash
bash build.sh --clean
```

Nếu file trung gian cũ gây lỗi sau khi đổi môi trường TeX, dọn rồi build lại:

```bash
bash build.sh --clean
bash build.sh
```

Khi build thất bại, xem thông báo lỗi trong Terminal và log:

```bash
less .build/ubuntu/main.log
```

Các ảnh PNG đã có sẵn trong `Images/`; build báo cáo không cần chạy lại Python, Node.js hoặc Mermaid. Không cần cài font Times New Roman riêng vì cấu hình hiện tại dùng Latin Modern trong TeX Live. Nếu gặp lỗi thiếu package `.sty`, kiểm tra đã cài đầy đủ các gói phía trên; xem `.build/ubuntu/main.log` để xác định file lỗi. Dùng Biber và TeX Live từ cùng kho Ubuntu để tránh lệch phiên bản `biblatex`.

### Overleaf

Trên Overleaf:

1. Upload toàn bộ file zip.
2. Mở `main.tex`.
3. Chọn compiler `XeLaTeX`.
4. Bibliography dùng `Biber`.
5. Compile theo chu trình: XeLaTeX → Biber → XeLaTeX → XeLaTeX.

## File cần sửa nhiều nhất

- `Preamble/metadata.tex`: thông tin bìa, tên đề tài, GVHD, sinh viên.
- `FrontMatter/summary_vi.tex`: tóm tắt tiếng Việt.
- `FrontMatter/abstract_en.tex`: abstract tiếng Anh.
- `FrontMatter/abbreviations.tex`: danh mục từ viết tắt.
- `Sections/*.tex`: nội dung từng chương.
- `References/refs.bib`: tài liệu tham khảo.

## Mục lục đã map

- Tóm tắt báo cáo
- Abstract
- Mục lục
- Danh mục từ viết tắt
- Danh mục hình
- Danh mục bảng
- Guideline -- Hướng dẫn viết báo cáo và LaTeX
- Chương 1 -- Giới thiệu
- Chương 2 -- Kiến thức và công nghệ nền tảng
- Chương 3 -- Công trình liên quan
- Chương 4 -- Hệ thống đề xuất
- Chương 5 -- Phân tích và Thiết kế
- Chương 6 -- Hiện thực và kiểm thử
- Chương 7 -- Đánh giá hệ thống
- Chương 8 -- Tổng kết
- Kế hoạch thực hiện Đồ án tốt nghiệp
- Tài liệu tham khảo

## Khi nộp bản chính thức

Comment dòng guideline trong `main.tex`:

```tex
% \input{Sections/00-Guideline}
```

## Quy tắc citation

Từ Chương 1 đến hết báo cáo, phần nào lấy ý tưởng, dữ liệu, nhận định, định nghĩa hoặc mô tả từ tài liệu khác thì phải trích dẫn trực tiếp tại đoạn đó bằng `\parencite{key}` hoặc `\textcite{key}`.
