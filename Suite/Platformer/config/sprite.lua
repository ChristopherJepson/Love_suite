sprite = {
   ["menuBackground"] = {
      ['file'] = "MainMenu/sprites/castle.png";
   }; 
   ["playerSheet"] = {
      ['file'] = "Platformer/sprites/playerSheet.png";
      ['ratio'] = 0.25;
      ['x'] = 130;
      ['y'] = 300;
      ['gridX'] = 614;
      ['gridY'] = 564;
      ['idle'] = {
         ['range'] = '1-15';
         ['row'] = 1;
         ['frameSpeed'] = 0.05;
      };
      ['jump'] = {
         ['range'] = '1-7';
         ['row'] = 2;
         ['frameSpeed'] = 0.05;
      };
      ['run'] = {
         ['range'] = '1-15';
         ['row'] = 3;
         ['frameSpeed'] = 0.05;
      };
   };
   ["enemySheet"] = {
      ['file'] = "Platformer/sprites/enemySheet.png";
      ['ratio'] = 1;
      ['x'] = 50;
      ['y'] = 65;
      ['gridX'] = 100;
      ['gridY'] = 79;
      ['run'] = {
         ['range'] = '1-2';
         ['row'] = 1;
         ['frameSpeed'] = 0.03;
      };
   };
   ["background"] = {
      ['file'] = "Platformer/sprites/background.png";
   };
};