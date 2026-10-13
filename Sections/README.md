# Cấu trúc nội dung báo cáo

Nội dung AIHub và Wispace được đưa trực tiếp vào `05-KhaiThacYeuCau.tex` và `06-PhanTichHeThong.tex`. Các file tách và thư mục trung gian đã được xóa để chỉ giữ một bản nội dung.

Phần luồng hoạt động Wispace đã được viết riêng cho 12 use-case Speaking và đưa trực tiếp vào chương Phân tích, gồm mô tả tương tác và 12 sơ đồ tuần tự theo mẫu được cung cấp. Ảnh và mã tạo sơ đồ nằm trong `Images/Sequence/Wispace/`. Các chương chưa có nội dung thay thế và mục DFD hiện tại được giữ nguyên.

## Điểm cần đối chiếu trong nguồn

- `wispace.tex`: phần Luồng hoạt động (08) mô tả nghiệp vụ AIHub (API Key, cURL Sandbox, Academic Lab), chưa khớp mô-đun Speaking. Bản lặp này đã được xóa khỏi chương Phân tích; chỉ giữ luồng AIHub một lần.
- `wispace.tex`: lược đồ tổng quan (06) ghi 17 use-case và 4 phân hệ, nhưng liệt kê 3 phân hệ AIHub; phần đặc tả chi tiết (07) có 12 use-case.
- AIHub: phần tổng quan đã được đồng bộ thành 20 use-case; mỗi đặc tả dùng một ảnh `usecase_uc01_portal_auth.jpg` đến `usecase_uc20_audit_logs.jpg` trong `Images/Usecase/AIHub/`, theo mẫu Wispace. Macro chèn ảnh được khai báo trực tiếp trong `06-PhanTichHeThong.tex`, giống Wispace; dữ liệu và mã tạo ảnh nằm trong `Images/Usecase/AIHub/source/`. Bộ 20 ảnh Speaking bị đặt nhầm trong thư mục ApiHub đã được xóa.
- Wispace: 13 đường dẫn ảnh tổng quan và chi tiết đã được sửa về `Images/Usecase/Wispace/` và kiểm tra tồn tại.
- AIHub: 20 sơ đồ tuần tự nằm trong `Images/Sequence/AIHub/`, từ `sequence_uc01_portal_auth.png` đến `sequence_uc20_audit_logs.png`. Các đường dẫn `sq_uc...` cũ đã được thay trong chương Phân tích. Bộ ảnh dùng cùng mẫu với Wispace, được chèn trên trang dọc và cắt bớt viền trắng; mã tạo ảnh nằm trong thư mục `source/`.

Các điểm trên có sẵn trong tài liệu được cung cấp, cần đối chiếu trước khi chốt báo cáo.
