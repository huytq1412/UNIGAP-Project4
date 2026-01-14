# Hệ Thống Báo Cáo Động & tối ưu hóa PostgreSQL cho dữ liệu eCommerce

![SQL](https://img.shields.io/badge/Language-SQL-orange) ![Database](https://img.shields.io/badge/Database-PostgreSQL-blue) ![Status](https://img.shields.io/badge/Status-Completed-green)

## 📖 Tổng Quan

Dự án này minh họa các kỹ thuật **Tối ưu hóa Cơ sở dữ liệu (Database Optimization)** nâng cao trong PostgreSQL, tập trung vào chiến lược **Table Partitioning (Phân mảnh bảng)** và **Indexing (Đánh chỉ mục)**. Dự án thực hiện so sánh hiệu năng thực tế giữa các truy vấn phân tích phức tạp trước và sau khi tối ưu hóa.

Ngoài ra, dự án còn xây dựng một **Hệ thống Báo cáo Động (Dynamic Reporting System)** sử dụng Stored Functions nhằm cung cấp các báo cáo nghiệp vụ linh hoạt.

---

Cấu trúc của Project4 

```
Project4/
├── src/           
│   ├── query_old.sql               # Chứa các câu truy vấn chạy trên cấu trúc bảng thường (chưa partition)
│   ├── partition.sql               # Script tái cấu trúc bảng orders và order_item sử dụng Range Partitioning (theo tháng) và thực hiện di chuyển dữ liệu 
│   ├── query_after_partition.sql   # Chứa các câu truy vấn tương tự chạy trên cấu trúc bảng đã partition 
│   └── dynamic_report.sql          # Script tạo các Index tối ưu và các Stored Functions báo cáo động
├── .gitignore                      # File loại trừ khi đẩy lên git
└── README.md                       # Tài liệu hướng dẫn sử dụng
```


---

## 🚀 Phần 1: Kỹ Thuật Tối Ưu Hóa

### 1. Kịch Bản
Phân tích các chỉ số hiệu năng (Thời gian thực thi & I/O Buffers) để tối ưu hóa các kịch bản sau:
1.  **Total Revenue per Month:** Tổng hợp doanh thu theo tháng.
2.  **Orders Filtered by Seller and Date:** Lọc đơn hàng theo dải ngày và danh sách người bán.
3.  **Filter Data by Product ID:** Tìm kiếm dữ liệu chi tiết với high-selectivity.
4.  **Find Order with Highest Amount:** Sắp xếp và giới hạn trên tập dữ liệu lớn.
5.  **List Products with Highest Quantity:** Tổng hợp toàn cục và sắp xếp.
6.  **Orders by Seller (Specific Month):** Truy cập vào một phân vùng cụ thể.
7.  **Revenue per Product per Month:** Group By nhiều cấp độ.
8.  **Products Sold per Seller:** Phép Join nặng giữa các bảng lớn.

### 2. Chiến Lược Áp Dụng
* **Partitioning:** Sử dụng Range Partitioning trên cột `order_date`.
* **Indexing:*** Sử dụng Index cho Partition Joins (`order_id`, `order_date`).
* **Tuning:** Kích hoạt `enable_partitionwise_join` và `enable_partitionwise_aggregate`.

---

## 📊 Phần 2: Hệ Thống Báo Cáo Động

File `dynamic_report.sql` chứa các Stored Functions báo cáo động.

### 🛠 Tính Năng Tối Ưu
* **Partition Pruning:** Tất cả báo cáo bắt buộc phải có tham số `start_date` và `end_date` để tận dụng việc partition và index.
* **Strict Typing:** Sử dụng kiểu `BIGINT` cho các phép đếm/tổng để tránh lỗi tràn số (Overflow).
* **Flexible Input:** Chấp nhận đầu vào dạng chuỗi phân cách bởi dấu phẩy (VD: `'1,2,3'`) và tự động chuyển đổi sang Mảng (Array) để lọc tối ưu (`= ANY(...)`).

### 📋 Danh Sách Báo Cáo

#### 1. Monthly Revenue Report (Báo cáo Doanh thu Tháng)
* **Mục tiêu:** Tổng hợp doanh thu và số lượng đơn hàng theo tháng.
* **Function:** `get_monthly_revenue(p_start_date, p_end_date)`
* **Cột trả về:** `month`, `total_orders`, `total_quantity`, `total_revenue`

#### 2. Daily Revenue Report (Báo cáo Doanh thu Ngày)
* **Mục tiêu:** Chi tiết theo ngày với tùy chọn lọc theo sản phẩm.
* **Function:** `get_daily_revenue_report(p_start_date, p_end_date, p_product_list)`
* **Bộ lọc:** p_product_list (Optional).
* **Cột trả về:** `date`, `total_orders`, `total_quantity`, `total_revenue`

#### 3. Seller Performance Report (Hiệu quả Người bán)
* **Mục tiêu:** So sánh hiệu suất kinh doanh của các Seller.
* **Function:** `get_seller_performance_report(p_start_date, p_end_date, p_category_id, p_brand_id)`
* **Bộ lọc:** p_category_id, p_brand_id (Optional).
* **Cột trả về:** `seller_id`, `seller_name`, `total_orders`, `total_quantity`, `total_revenue`

#### 4. Top Products per Brand (Sản phẩm bán chạy theo Brand)
* **Mục tiêu:** Tìm ra các sản phẩm bán chạy nhất của từng thương hiệu.
* **Function:** `get_top_products_per_brand(p_start_date, p_end_date, p_seller_list)`
* **Cột trả về:** `brand_id`, `brand_name`, `product_id`, `product_name`, `total_quantity`, `total_revenue`

#### 5. Orders Status Summary (Tổng hợp Trạng thái Đơn hàng)
* **Mục tiêu:** Đếm số lượng đơn hàng theo trạng thái.
* **Function:** `get_order_status_summary(p_start_date, p_end_date, p_seller_list, p_category_list)`
* **Cột trả về:** `status`, `total_orders`, `total_revenue`
---

## ⚙️ Hướng Dẫn Sử Dụng

### Các bước thực thi
1. **Import cơ sở dữ liệu:**: Mở file script tạo bảng (nếu có) hoặc import dữ liệu mẫu vào SQL Tool của bạn.
2. **Chạy Baseline:** Thực thi file `query_old.sql` để ghi nhận hiệu năng ban đầu.
3. **Áp dụng Partitioning:** Thực thi file `partition.sql` để tạo phân vùng và di chuyển dữ liệu.
4. **Chạy So sánh:** Thực thi file `query_after_partition.sql` và so sánh kết quả `EXPLAIN ANALYZE`.
5. **Cài đặt Báo cáo:** Thực thi file `dynamic_report.sql` để tạo index và functions.
