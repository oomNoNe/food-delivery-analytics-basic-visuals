🇬🇧 [Read in English](./README.md)

# FoodOps Analytics: การวิเคราะห์ประสิทธิภาพการจัดส่งและการเติบโตทางธุรกิจ

**คำถามทางธุรกิจ:** ทำไม delivery ถึงช้าในบางเมือง? โปรโมชั่นที่ทำอยู่คุ้มค่าเงินจริงไหม?

โปรเจกต์นี้วิเคราะห์ order อาหารเดลิเวอรี่ 8,000 รายการ ใน 6 เมืองของไทย (ม.ค. 2025–มี.ค. 2026) ครอบคลุมขั้นตอนทำงานแบบ analyst ครบวงจร: ทำความสะอาดข้อมูล สำรวจข้อมูล ทดสอบทางสถิติ เขียน SQL และสร้าง dashboard

**[▶ ดู Dashboard แบบ Live](https://app.powerbi.com/view?r=eyJrIjoiMWU5OTIzYWQtYTQ2Ni00MDBkLWI4MjItODg4Mjk4NjE5YWU5IiwidCI6ImNmODFmMWRmLWRlNTktNGMyOS05MWRhLWEyZGZkMDRhYTc1MSIsImMiOjEwfQ%3D%3D)**

---

## สรุปผลการวิเคราะห์

| ผลที่พบ | หลักฐาน | ทำไมถึงสำคัญ |
|---|---|---|
| **ปัญหาจริงคือ traffic ไม่ใช่เมือง** | delivery time ขึ้นอยู่กับ traffic และระยะทางเป็นหลัก (R² = 0.90) traffic ระดับ Severe: 49.3 นาที ระดับ Low: 26.8 นาที ส่วนตัวเมืองเองไม่ได้ทำให้ต่างกัน | ควรแก้ที่การวางแผนเส้นทาง/คนขับ ไม่ใช่ออกกฎแยกตามเมือง |
| **โปรโมชั่นไม่ได้เพิ่มยอดสั่งซื้อต่อออเดอร์** | ยอดเฉลี่ยต่อออเดอร์: ฿252.62 (มีโปร) vs ฿250.65 (ไม่มีโปร) ต่างกันแค่ ~฿2 แต่เสียส่วนลดไป ฿99,004 | โปรโมชั่นแบบนี้อาจไม่คุ้มต้นทุน ควรลองแบบอื่น เช่น ส่งฟรี |
| **Phuket มี order ถูกยกเลิกมากที่สุด** | 5.73% ของ order ใน Phuket ถูกยกเลิก สูงสุดใน 6 เมือง (Khon Kaen ต่ำสุดที่ 3.51%) | ควรตรวจสอบว่าปัญหาที่ Phuket มาจากร้านอาหาร คนขับ หรือ demand |
| **ยิ่งส่งช้า ยิ่งได้ rating แย่ลง** | delivery time ที่นานขึ้นทำให้ rating ลดลงอย่างมีนัยสำคัญ (p < 0.001) แม้จะควบคุมปัจจัยอื่นแล้ว | ส่งเร็วขึ้นไม่ใช่แค่ตัวเลข ops ที่ดีขึ้น แต่ลูกค้าพอใจมากขึ้นจริง |

---

## การทดสอบสมมติฐาน (Hypothesis Testing)

ทุกผลที่พบมีการทดสอบทางสถิติ (regression ใน R) รองรับ ไม่ใช่แค่ดูตัวเลขเทียบกันเฉยๆ

| สมมติฐาน (H0: ไม่มีผล) | ผลลัพธ์ | สรุป |
|---|---|---|
| ระดับ traffic ไม่มีผลต่อ delivery time | p < 2e-16 ทุกระดับ | **ปฏิเสธ H0** — traffic มีผลจริงและชัดเจน |
| ระยะทางไม่มีผลต่อ delivery time | p < 2e-16 | **ปฏิเสธ H0** — ระยะทางเป็นตัวขับเคลื่อนหลัก |
| เมืองไม่มีผลต่อ delivery time (เมื่อควบคุม traffic, weather, ระยะทางแล้ว) | p > 0.26 ทุกเมือง | **ยอมรับ H0** — เมืองไม่มีผลด้วยตัวเอง |
| delivery time ไม่มีผลต่อ customer rating | p < 2e-16 | **ปฏิเสธ H0** — ส่งช้าจริงทำให้ rating แย่ลง |

### Model 1: Delivery Time
`delivery_time_min ~ traffic_level + distance_km + prep_time_min + weather + courier_vehicle + city + hour`

**R² = 0.8997 | p-value < 2.2e-16**

<img width="835" height="550" alt="image" src="https://github.com/user-attachments/assets/5821c504-5c14-4066-9921-dd7b5ea41361" />
<img width="769" height="487" alt="image" src="https://github.com/user-attachments/assets/56c02170-cc52-4781-b4e8-21152d8537e5" />


### Model 2: Customer Rating
`customer_rating ~ delivery_time_min + distance_km + prep_time_min + traffic_level + weather + city + restaurant_category`

**R² = 0.301 | p-value < 2.2e-16 | ค่า coefficient ของ delivery_time_min = -0.0156** (ทุก 1 นาทีที่ส่งช้าขึ้น rating ลดลง ~0.016)

<img width="660" height="649" alt="image" src="https://github.com/user-attachments/assets/c1153241-ee50-470f-93cf-5c43d2268753" />
<img width="663" height="591" alt="image" src="https://github.com/user-attachments/assets/119bbcb4-e23e-43ae-9baf-12c364c971e3" />


โค้ด R ฉบับเต็ม: [`r/regression_analysis.R`](./r/regression_analysis.R)

---

## ข้อเสนอแนะ

1. โฟกัสการวางแผนคนขับ/เส้นทางในช่วง traffic หนัก มากกว่าการแก้แบบแยกตามเมือง
2. ทดลองโปรโมชั่นรูปแบบใหม่ (เช่น ส่งฟรี) ก่อนใช้เงินกับส่วนลดเพิ่ม
3. ตรวจสอบการดำเนินงานที่ Phuket อย่างละเอียดเพื่อลดอัตราการยกเลิก

---

## เครื่องมือที่ใช้

| ขั้นตอน | เครื่องมือ | ใช้ทำอะไร |
|---|---|---|
| ทำความสะอาด/สำรวจข้อมูล | **Python** (pandas) | แก้ข้อมูลที่ไม่สมบูรณ์ สำรวจคำถามพื้นฐาน |
| สถิติ | **R** | Regression model ทดสอบว่าอะไรมีผลต่อ delivery time และ rating จริง |
| Query ข้อมูล | **SQL** (SQLite) | ตอบคำถามธุรกิจ 6 ข้อ ใช้ `GROUP BY`, `HAVING`, `CASE WHEN`, window function |
| Dashboard | **Power BI** | กราฟโต้ตอบได้ มี filter เผยแพร่ออนไลน์ |

## โครงสร้าง Repo

```
food-delivery-analytics/
├── README.md
├── notebooks/
│   └── analysis.ipynb          # Python: cleaning + exploration
├── r/
│   └── regression_analysis.R   # R: regression models
├── sql/
│   └── sql_queries.sql         # SQL: 6 business questions
├── data/
│   └── food_clean.csv          # ข้อมูลที่ clean แล้ว ใช้ร่วมกันทุกส่วน
└── assets/
    └── (ภาพผล regression ที่ใช้ใน README นี้)
```

## ขั้นตอนการวิเคราะห์

- **Regression model (R):** โมเดลแรกทดสอบว่าอะไรมีผลต่อ delivery time โมเดลที่สองทดสอบว่าอะไรมีผลต่อ customer rating
- **SQL query:** ตอบคำถามธุรกิจเดียวกับที่ทำใน Python แค่เขียนเป็น SQL แทน ผลลัพธ์เช็คแล้วว่าตรงกับที่ได้จาก Python
- **Dashboard:** ใช้ไฟล์ CSV ที่ clean แล้วไฟล์เดียวกันกับทุกส่วนของโปรเจกต์ ทำให้ตัวเลขตรงกันหมด

## ข้อจำกัดและแผนต่อยอด

- ข้อมูลเป็น synthetic data และครอบคลุมช่วงเวลาสั้น ทำให้เห็น pattern ตามฤดูกาลได้ยาก
- `customer_rating` มีค่าหายไปประมาณ 9% ยังไม่ยืนยันว่าหายแบบสุ่มหรือไม่ ซึ่งอาจทำให้โมเดล rating มี bias เล็กน้อย
- แผนต่อไป: ทำ A/B test จริงกับรูปแบบโปรโมชั่น และลองสร้างโมเดลที่ทำนาย delivery time ล่วงหน้า (ไม่ใช่แค่อธิบายย้อนหลัง)
