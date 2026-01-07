# Bee Movies Data Analysis Project

![SQL](https://img.shields.io/badge/Language-SQL-orange) ![Database](https://img.shields.io/badge/Database-PostgreSQL-blue) ![Status](https://img.shields.io/badge/Status-Completed-green)

## 📋 Giới thiệu 

Dự án này là một bài phân tích dữ liệu chuyên sâu dựa trên cơ sở dữ liệu điện ảnh dành cho **Bee Movies** - một công ty sản xuất phim đang có kế hoạch ra mắt dự án phim mới.

Mục tiêu của dự án là sử dụng SQL để khai thác dữ liệu lịch sử (phim, diễn viên, đạo diễn, doanh thu, đánh giá...), từ đó đưa ra các đề xuất chiến lược giúp Bee Movies giảm thiểu rủi ro và tối đa hóa khả năng thành công cho bộ phim sắp tới.

## 📂 Cấu trúc dữ liệu (Data Schema)

Cơ sở dữ liệu bao gồm các bảng chính liên kết với nhau:

- **movie**: Thông tin cơ bản về phim (tên, năm, thời lượng, doanh thu...).
- **genre**: Thể loại phim.
- **ratings**: Điểm đánh giá (AVG rating, total votes, median rating).
- **names**: Thông tin cá nhân của diễn viên, đạo diễn.
- **role_mapping**: Bảng nối xác định vai trò (actor/actress) trong phim.
- **director_mapping**: Bảng nối xác định đạo diễn của phim.

## 🛠 Công cụ sử dụng 

- **Ngôn ngữ:** SQL.
- **Hệ quản trị CSDL:** PostgreSQL.
- **Công cụ:** pgAdmin 4 / DBeaver .

## 🔍 Nội dung phân tích (Analysis Highlights)

Dự án được chia làm 4 phần chính (Segments):

1.  **Tổng quan thị trường:** Phân tích xu hướng phát hành phim theo năm/tháng và các thể loại phổ biến.
2.  **Đánh giá & Sản xuất:** Tìm ra các hãng sản xuất hàng đầu và các bộ phim có rating cao nhất.
3.  **Phân tích Nhân sự:** Tìm kiếm các đạo diễn, diễn viên tài năng nhất (dựa trên rating và số lượng phim) để đề xuất hợp tác.
4.  **Phân tích Nâng cao:** Sử dụng Window Functions để tính toán các chỉ số phức tạp như *Moving Average*, *Running Total* và khoảng thời gian trung bình giữa các phim của đạo diễn.

## 💡 Đề xuất 

Dựa trên quá trình phân tích, dưới đây là tóm tắt các đề xuất chiến lược (chi tiết xem trong file PDF):

- **Thể loại:** Nên tập trung vào **Drama** (Chính kịch) hoặc **Thriller** (Giật gân) vì lượng khán giả lớn và rating ổn định.
- **Thị trường:** **Ấn Độ** và **Mỹ** là hai thị trường sản xuất sôi động nhất.
- **Thời lượng:** Độ dài lý tưởng cho phim là từ **100 đến 110 phút**.
- **Nhân sự đề xuất:**
  - *Đạo diễn:* James Mangold (Quốc tế), A.L. Vijay.
  - *Diễn viên:* Vijay Sethupathi, Taapsee Pannu (cho thị trường Ấn Độ), Laura Dern (cho dòng phim Drama).
- **Đối tác:** Marvel Studios (Doanh thu) hoặc Dream Warrior Pictures (Chất lượng nghệ thuật).

**Đọc báo cáo chi tiết tại đây:** [BeeMovies_Summary.pdf](./BeeMovies_Summary.pdf)

## 🚀 Hướng dẫn chạy (How to Run)


1. **Import cơ sở dữ liệu:**
    - Mở file script tạo bảng (nếu có) hoặc import dữ liệu mẫu vào SQL Tool của bạn.
2. **Chạy file truy vấn:**
    - Mở file `Project4.sql` (hoặc tên file script chính của bạn).
    - Thực thi từng Segment để xem kết quả phân tích.
