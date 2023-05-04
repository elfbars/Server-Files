
-- local cfg = {}

-- -- example of study transformer
-- local itemtr_study = {
--   name="Bookcase", -- menu name
--   r=0,g=255,b=0, -- color
--   max_units=20,
--   units_per_minute=10,
--   x=0,y=0,z=0, -- pos (doesn't matter as home component)
--   radius=1.1, height=1.5, -- area
--   recipes = {
--     ["Chemicals book"] = { -- action name
--       description="Read a chemicals book", -- action description
--       in_money=0, -- money taken per unit
--       out_money=0, -- money earned per unit
--       reagents={}, -- items taken per unit
--       products={}, -- items given per unit
--       aptitudes={ -- optional
--         ["science.chemicals"] = 1 -- "group.aptitude", give 1 exp per unit
--       }
--     },
--     ["Mathematics book"] = { -- action name
--       description="Read a mathematics book", -- action description
--       in_money=0, -- money taken per unit
--       out_money=0, -- money earned per unit
--       reagents={}, -- items taken per unit
--       products={}, -- items given per unit
--       aptitudes={ -- optional
--         ["science.mathematics"] = 1 -- "group.aptitude", give 1 exp per unit
--       }
--     }
--   }
-- }

-- ----------------------------------------------------------------------------------------- laboratory
-- local itemtr_laboratory = {
--   name="workbench", -- menu name
--   permissions = {"harvest.weed"}, -- job drug dealer required to use
--   r=0,g=255,b=0, -- color
--   max_units=1000,
--   units_per_minute=200,
--   x=0,y=0,z=0, -- pos (doesn't matter as home component)
--   radius=1.1, height=1.5, -- area
--   recipes = {
--     ["cocaine"] = { -- action name
--       description="make cocaine", -- action description
--       in_money=500, -- money taken per unit
--       out_money=0, -- money earned per unit
--       reagents={ -- items taken per unit
--         ["benzoilmetilecgonina"] = 1
--       },
--       products={ -- items given per unit
--         ["cocaine"] = 5
--       },
--       aptitudes={ -- optional
--         ["laboratory.cocaine"] = 5, -- "group.aptitude", give 1 exp per unit
--         ["science.chemicals"] = 10
--       }
--     },
-- 	["weed"] = { -- action name
--       description="make weed", -- action description
--       in_money=500, -- money taken per unit
--       out_money=0, -- money earned per unit
--       reagents={ -- items taken per unit
--         ["seeds"] = 1
--       },
--       products={ -- items given per unit
--         ["weed"] = 5
--       },
--       aptitudes={ -- optional
--         ["laboratory.weed"] = 5, -- "group.aptitude", give 1 exp per unit
--         ["science.chemicals"] = 10
--       }
--     },
-- -----------------
-- 	["lsd"] = { -- action name
--       description="make lsd", -- action description
--       in_money=500, -- money taken per unit
--       out_money=0, -- money earned per unit
--       reagents={ -- items taken per unit
--         ["harness"] = 1
--       },
--       products={ -- items given per unit
--         ["lsd"] = 5
--       },
--       aptitudes={ -- optional
--         ["laboratory.lsd"] = 5, -- "group.aptitude", give 1 exp per unit
--         ["science.chemicals"] = 10
--       }
--     },
-- 	---------------------------------------------
--   }
-- }
-- ------------------------------------------------ hacker

-- --local itemtr_hacker = {
--   --name="hacker", -- menu name
--   --r=0,g=255,b=0, -- color
--   --max_units=20,
--   --units_per_minute=10,
--   --x=0,y=0,z=0, -- pos (doesn't matter as home component)
--   --radius=1.1, height=1.5, -- area
--   --recipes = {
--     --["logic pdf"] = { -- action name
--      --description="Read a logic pdf", -- action description
--       --in_money=0, -- money taken per unit
--       --out_money=0, -- money earned per unit
--       --reagents={}, -- items taken per unit
--       --products={}, -- items given per unit
--       --aptitudes={ -- optional
--         --["hacker.logic"] = 10 -- "group.aptitude", give 1 exp per unit
--       --}
--     --},
--     --["c++ pdf"] = { -- action name
--       --description="Read a C++ pdf", -- action description
--       --in_money=0, -- money taken per unit
--       --out_money=0, -- money earned per unit
--       --reagents={}, -- items taken per unit
--       --products={}, -- items given per unit
--       --aptitudes={ -- optional
--         --["hacker.c++"] = 1 -- "group.aptitude", give 1 exp per unit
--      -- }
--     --},
-- 	--["lua pdf"] = { -- action name
--      -- description="Read a C++ pdf", -- action description
--       --in_money=0, -- money taken per unit
--       --out_money=0, -- money earned per unit
--       --reagents={}, -- items taken per unit
--       --products={}, -- items given per unit
--       --aptitudes={ -- optional
--         --["hacker.lua"] = 1 -- "group.aptitude", give 1 exp per unit
--       --}
--     --},
-- 	--["hacking"] = { -- action name
--      -- description="hacking a Credit card informations", -- action description
--       --in_money=0, -- money taken per unit
--       --out_money=0, -- money earned per unit
--       --reagents={}, -- items taken per unit
--       --products={
-- 	  --["dirty_money"] = 5000
-- 	  --}, -- items given per unit
--       --aptitudes={ -- optional
--         --["hacker.lua"] = 1, -- "group.aptitude", give 1 exp per unit
--         --["hacker.c++"] = 1, -- "group.aptitude", give 1 exp per unit
--         --["hacker.logic"] = 1, -- "group.aptitude", give 1 exp per unit
--         --["hacker.hacking"] = 1 -- "group.aptitude", give 1 exp per unit
--       --}
--     --},
--   --}
-- --}

-- -- default flats positions from https://github.com/Nadochima/HomeGTAV/blob/master/List

-- -- define the home slots (each entry coordinate should be unique for ALL types)
-- -- each slots is a list of home components
-- --- {component,x,y,z} (optional _config)
-- --- the entry component is required
-- cfg.slot_types = {
-- }

-- return cfg
