# HCMUT Software Engineering Report Template

Template LaTeX cho báo cáo Đồ án chuyên ngành, đã map theo mục lục yêu cầu.

## Cách compile

Trên Overleaf:

1. Upload toàn bộ file zip.
2. Mở `main.tex`.
3. Chọn compiler `pdfLaTeX`.
4. Bibliography dùng `Biber`.
5. Compile theo chu trình: pdfLaTeX → Biber → pdfLaTeX → pdfLaTeX.

Trên Windows đã cài MiKTeX hoặc TeX Live, mở PowerShell tại thư mục dự án:

```powershell
.\build.ps1
```

Script chạy đầy đủ chu trình trên và tạo `main.pdf`; không cần Perl.
Nếu dùng `latexmk`, cần cài thêm Perl và chạy:

```powershell
latexmk -pdf -halt-on-error -file-line-error main.tex
```

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
