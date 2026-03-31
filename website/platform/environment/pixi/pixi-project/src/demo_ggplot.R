# 載入 ggplot2
library(ggplot2)

# 建立簡單資料
df <- data.frame(
  x = 1:10,
  y = c(2,3,5,7,11,13,17,19,23,29)
)

# 畫圖
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 3) +
  geom_line() +
  theme_minimal() +
  labs(
    title = "Simple ggplot2 demo",
    x = "X value",
    y = "Y value"
  )

# 顯示圖
print(p)

# 存成圖片
ggsave("demo_plot.png", plot = p, width = 6, height = 4)
