from PIL import Image
from pathlib import Path
# Requires Pillow; source images and crop boundaries are versioned for reproducibility.
root=Path(__file__).resolve().parents[1] / 'assets/01_creatures'
for id,name,bounds in [('CR002','Brumelo',[0,362,724,1086,1448,1810,2172]),('CR003','Ferru',[0,362,724,1086,1490,1810,2172])]:
 folder=root/f'{id}_{name}'
 im=Image.open(folder/'source'/f'{id}_G1_pose_study_20261028.png').convert('RGBA')
 out=Image.new('RGBA',(576,80))
 for i in range(6):
  part=im.crop((bounds[i],0,bounds[i+1],724))
  part.putalpha(part.getchannel('A').point(lambda a: 255 if a>=160 else 0))
  box=part.getchannel('A').getbbox(); part=part.crop(box)
  part=part.resize((round(part.width*.225),round(part.height*.225)),Image.Resampling.NEAREST)
  out.alpha_composite(part,(i*96+(96-part.width)//2,77-part.height))
 out.save(folder/'sprite_sheets'/f'{id}_G1_6poses_canon_study_96x80.png', optimize=True)
