"""Render the 20 AIHub UML diagrams in the Wispace visual template.

Run with Pillow installed. Source content is in usecases.json beside this file.
"""
from pathlib import Path
import json
import math
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
GRAY = '#b2b3ab'
BLUE = '#3282ce'
FILL = '#e8f0fa'
INK = '#111111'
SCALE = 2
W, H = 2400, 1350
FONT_DIR = Path('C:/Windows/Fonts')


def render(case):
    im = Image.new('RGB', (W * SCALE, H * SCALE), 'white')
    draw = ImageDraw.Draw(im)

    def font(size, bold=False):
        return ImageFont.truetype(str(FONT_DIR / ('arialbd.ttf' if bold else 'arial.ttf')), size * SCALE)

    def line(points, color=GRAY, width=4):
        draw.line([(round(x * SCALE), round(y * SCALE)) for x, y in points], fill=color, width=width * SCALE)

    def text(value, center, max_width, size=38, bold=False, color=INK):
        f = font(size, bold)
        rows = []
        for paragraph in value.split('\n'):
            row = ''
            for word in paragraph.split():
                candidate = (row + ' ' + word).strip()
                if row and draw.textlength(candidate, font=f) > max_width * SCALE:
                    rows.append(row)
                    row = word
                else:
                    row = candidate
            rows.append(row)
        spacing = int(size * 1.25 * SCALE)
        x, y = center[0] * SCALE, center[1] * SCALE
        y -= spacing * (len(rows) - 1) / 2
        for row in rows:
            draw.text((x, y), row, font=f, fill=color, anchor='mm')
            y += spacing
        return len(rows)

    def oval(center, value, primary=False):
        x, y = center
        rx, ry = (310, 100) if primary else (300, 88)
        draw.ellipse(((x-rx)*SCALE, (y-ry)*SCALE, (x+rx)*SCALE, (y+ry)*SCALE),
                     fill=FILL if primary else 'white', outline=BLUE if primary else GRAY,
                     width=(6 if primary else 4)*SCALE)
        assert text(value, center, 490, 40 if primary else 37, primary) <= 3, value

    def actor(x, y, label):
        draw.ellipse(((x-28)*SCALE, (y-105)*SCALE, (x+28)*SCALE, (y-49)*SCALE),
                     outline=GRAY, width=4*SCALE)
        line([(x,y-49),(x,y+25)])
        line([(x-45,y-12),(x+45,y-12)])
        line([(x,y+25),(x-40,y+90)])
        line([(x,y+25),(x+40,y+90)])
        text(label, (x,y+155), 310, 36)

    def edge(a, b, extension=False):
        # Intersections with the two ellipses keep arrowheads on their borders.
        def intersect(c, toward, rx, ry):
            dx, dy = toward[0]-c[0], toward[1]-c[1]
            k = 1/math.sqrt((dx/rx)**2+(dy/ry)**2)
            return c[0]+dx*k, c[1]+dy*k
        start = intersect(a,b,300 if extension else 310,88 if extension else 100)
        end = intersect(b,a,310 if extension else 300,100 if extension else 88)
        dx,dy = end[0]-start[0],end[1]-start[1]
        length = math.hypot(dx,dy)
        ux,uy = dx/length,dy/length
        for distance in range(0,int(length),28):
            last = min(distance+15,length)
            line([(start[0]+ux*distance,start[1]+uy*distance),
                  (start[0]+ux*last,start[1]+uy*last)],width=3)
        line([(end[0]-ux*22-uy*10,end[1]-uy*22+ux*10),end,
              (end[0]-ux*22+uy*10,end[1]-uy*22-ux*10)],width=3)
        # Relationship label stays above the connection, clear of oval text.
        middle = ((start[0]+end[0])/2,(start[1]+end[1])/2-32)
        text('«extend»' if extension else '«include»',middle,250,30,color='#666666')

    title = f"Use-case {case['id']:02d}: {case['name']}"
    assert text(title,(W/2,75),2200,48,True) <= 2
    draw.rounded_rectangle((440*SCALE,180*SCALE,1950*SCALE,1220*SCALE),
                           radius=32*SCALE,outline=GRAY,width=4*SCALE)
    text('AIHub Platform',(1195,240),1350,40,True,'#555555')
    main = (825,690)
    targets = [(1580,440),(1580,790)]
    if case['extension']:
        targets = [(1580,405),(1580,685)]
    line([(270,690),(main[0]-310,690)])
    actor(190,690,case['actor'])
    for center, value in zip(targets,case['includes']):
        edge(main,center)
        oval(center,value)
    if case['extension']:
        ext = (1580,1000)
        edge(ext,main,True)
        oval(ext,case['extension'])
        assert text(case['condition'],(1580,1128),640,29,color='#666666') <= 2
    oval(main,case['name'],True)
    if case.get('support'):
        target = targets[case.get('support_target',1)]
        line([(target[0]+300,target[1]),(2130,target[1])])
        actor(2210,target[1],case['support'])
    result = im.resize((W,H),Image.Resampling.LANCZOS)
    output = ROOT / case['filename']
    result.save(output,quality=96,subsampling=0,dpi=(200,200))
    return output


if __name__ == '__main__':
    data = json.loads((Path(__file__).parent / 'usecases.json').read_text(encoding='utf-8'))
    assert len(data) == 20 and [c['id'] for c in data] == list(range(1,21))
    for case in data:
        path = render(case)
        with Image.open(path) as check:
            assert check.size == (W,H)
            check.verify()
    print('Rendered and verified 20 AIHub diagrams (2400 x 1350).')
