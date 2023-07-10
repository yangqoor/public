import contextlib
with contextlib.redirect_stdout(None):     # 禁用版本输出
    import pygame

"""游戏初始化"""
pygame.init()

# 创建游戏窗口
screen = pygame.display.set_mode((480, 700))

# 绘制背景图像
# 1> image模块 load方法 加载图像数据
bg_img = pygame.image.load("./images/background.png")
# 2> 屏幕对象surface 的 blit 绘制图像
screen.blit(bg_img, (0, 0))
# 3> 窗口模块 display 的 update 更新屏幕显示
# pygame.display.update()

# 绘制英雄的飞机
hero = pygame.image.load("./images/me1.png")
screen.blit(hero, (150, 300))
# 可以在所有的绘制工作完成之后，统一调用 update 方法
pygame.display.update()

# 创建时钟对象
clock = pygame.time.Clock()

# 1. 定义 rect 记录飞机的初始位置
hero_rect = pygame.Rect(150, 300, 102, 126)

"""游戏正式开始"""
while True:
    # 指定循环体内部的代码执行频率
    clock.tick(60)

    # 2. 修改飞机位置
    hero_rect.y -= 1

    # 3. 调用blit 绘制图像
    # 重新绘制背景，覆盖飞机残影
    screen.blit(bg_img, (0, 0))
    screen.blit(hero, hero_rect)

    # 4. update 更新显示
    pygame.display.update()


pygame.quit()
