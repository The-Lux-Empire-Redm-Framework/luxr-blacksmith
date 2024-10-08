
# The Lux Empire RedM Framework

- Discord: https://discord.gg/Aj7KGKMDBU
- GitHub: https://github.com/iboss21
- Tebex Store: https://theluxempire.tebex.io/
- The Lux RedM Framework: https://github.com/The-Lux-Empire-Redm-Framework
- The Lux Empire FiveM Project: https://github.com/TheLuxEmpire-Success

# luxr-blacksmith

- For The Lux RedM Framework: https://github.com/The-Lux-Empire-Redm-Framework

# Dependencies

- luxr-core
- luxr-target
- ox_lib

# Installation

- Ensure that the dependencies are added and started.
- Add `luxr-blacksmith` to your resources folder.
- Items have already been added to `luxr-core`; check you have the latest version.
- Images have already been added to `luxr-core`; check you have the latest version.
- Add the following tables to your database: `luxr-blacksmith.sql`

# Add Jobs

- Add the following jobs to `luxr-core/shared/jobs.lua`:

```lua
['valblacksmith'] = {
    label = 'Valentine Blacksmith',
    type = 'blacksmith',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Recruit', payment = 10 },
        ['1'] = { name = 'Blacksmith', payment = 15 },
        ['2'] = { name = 'Master Blacksmith', isboss = true, payment = 25 },
    },
},
['blkblacksmith'] = {
    label = 'Blackwater Blacksmith',
    type = 'blacksmith',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Recruit', payment = 10 },
        ['1'] = { name = 'Blacksmith', payment = 15 },
        ['2'] = { name = 'Master Blacksmith', isboss = true, payment = 25 },
    },
},
['vanblacksmith'] = {
    label = 'Van-Horn Blacksmith',
    type = 'blacksmith',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Recruit', payment = 10 },
        ['1'] = { name = 'Blacksmith', payment = 15 },
        ['2'] = { name = 'Master Blacksmith', isboss = true, payment = 25 },
    },
},
['stdblacksmith'] = {
    label = 'StDenis Blacksmith',
    type = 'blacksmith',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Recruit', payment = 10 },
        ['1'] = { name = 'Blacksmith', payment = 15 },
        ['2'] = { name = 'Master Blacksmith', isboss = true, payment = 25 },
    },
},
['strblacksmith'] = {
    label = 'Strawberry Blacksmith',
    type = 'blacksmith',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Recruit', payment = 10 },
        ['1'] = { name = 'Blacksmith', payment = 15 },
        ['2'] = { name = 'Master Blacksmith', isboss = true, payment = 25 },
    },
},
['macblacksmith'] = {
    label = 'Macfarlane Blacksmith',
    type = 'blacksmith',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Recruit', payment = 10 },
        ['1'] = { name = 'Blacksmith', payment = 15 },
        ['2'] = { name = 'Master Blacksmith', isboss = true, payment = 25 },
    },
},
['spiblacksmith'] = {
    label = 'Spider Blacksmith',
    type = 'blacksmith',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Recruit', payment = 10 },
        ['1'] = { name = 'Blacksmith', payment = 15 },
        ['2'] = { name = 'Master Blacksmith', isboss = true, payment = 25 },
    },
},
['tumblacksmith'] = {
    label = 'Tumbleweed Blacksmith',
    type = 'blacksmith',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Recruit', payment = 10 },
        ['1'] = { name = 'Blacksmith', payment = 15 },
        ['2'] = { name = 'Master Blacksmith', isboss = true, payment = 25 },
    },
},
```

# Add SQL

```sql
CREATE TABLE `luxr_blacksmith` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `blacksmithid` varchar(50) DEFAULT NULL,
    `owner` varchar(50) DEFAULT NULL,
    `rent` int(3) NOT NULL DEFAULT 0,
    `status` varchar(50) DEFAULT 'closed',
    `money` double(11,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `luxr_blacksmith_stock` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `blacksmithid` varchar(50) DEFAULT NULL,
    `item` varchar(50) DEFAULT NULL,
    `stock` int(11) NOT NULL DEFAULT 0,
    `price` double(11,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `luxr_blacksmith` (`blacksmithid`, `owner`, `money`) VALUES
('valblacksmith', 'vacant', 0.00),
('blkblacksmith', 'vacant', 0.00),
('vanblacksmith', 'vacant', 0.00),
('stdblacksmith', 'vacant', 0.00),
('strblacksmith', 'vacant', 0.00),
('macblacksmith', 'vacant', 0.00),
('spiblacksmith', 'vacant', 0.00),
('tumblacksmith', 'vacant', 0.00);

INSERT INTO `management_funds` (`job_name`, `amount`, `type`) VALUES
('valblacksmith', 0, 'boss'),
('blkblacksmith', 0, 'boss'),
('vanblacksmith', 0, 'boss'),
('stdblacksmith', 0, 'boss'),
('strblacksmith', 0, 'boss'),
('macblacksmith', 0, 'boss'),
('spiblacksmith', 0, 'boss'),
('tumblacksmith', 0, 'boss');
```

# Starting the Resource

- Add the following to your `server.cfg` file:

```cfg
ensure luxr-blacksmith
```

