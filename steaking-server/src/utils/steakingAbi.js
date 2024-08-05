const steakingAbi = [
    {
        type: "constructor",
        inputs: [
            {
                name: "_weth",
                type: "address",
            },
        ],
        stateMutability: "nonpayable",
    },
    {
        type: "function",
        name: "WETH",
        inputs: [],
        outputs: [
            {
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "depositIntoVault",
        inputs: [],
        outputs: [
            {
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "nonpayable",
    },
    {
        type: "function",
        name: "getMinimumStakingAmount",
        inputs: [],
        outputs: [
            {
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "hasStakingPeriodEnded",
        inputs: [],
        outputs: [
            {
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "owner",
        inputs: [],
        outputs: [
            {
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "setVaultAddress",
        inputs: [
            {
                name: "_vault",
                type: "address",
            },
        ],
        outputs: [],
        stateMutability: "nonpayable",
    },
    {
        type: "function",
        name: "stake",
        inputs: [
            {
                name: "_onBehalfOf",
                type: "address",
            },
        ],
        outputs: [],
        stateMutability: "payable",
    },
    {
        type: "function",
        name: "totalAmountStaked",
        inputs: [],
        outputs: [
            {
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "unstake",
        inputs: [
            {
                name: "_amount",
                type: "uint256",
            },
            {
                name: "_to",
                type: "address",
            },
        ],
        outputs: [],
        stateMutability: "nonpayable",
    },
    {
        type: "function",
        name: "usersToStakes",
        inputs: [
            {
                name: "arg0",
                type: "address",
            },
        ],
        outputs: [
            {
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "vault",
        inputs: [],
        outputs: [
            {
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "event",
        name: "DepositedIntoVault",
        inputs: [
            {
                name: "by",
                type: "address",
                indexed: true,
            },
            {
                name: "amount",
                type: "uint256",
                indexed: true,
            },
            {
                name: "sharesReceived",
                type: "uint256",
                indexed: true,
            },
        ],
        anonymous: false,
    },
    {
        type: "event",
        name: "Staked",
        inputs: [
            {
                name: "by",
                type: "address",
                indexed: true,
            },
            {
                name: "amount",
                type: "uint256",
                indexed: true,
            },
            {
                name: "onBehalfOf",
                type: "address",
                indexed: true,
            },
        ],
        anonymous: false,
    },
    {
        type: "event",
        name: "Unstaked",
        inputs: [
            {
                name: "by",
                type: "address",
                indexed: true,
            },
            {
                name: "amount",
                type: "uint256",
                indexed: true,
            },
            {
                name: "to",
                type: "address",
                indexed: false,
            },
        ],
        anonymous: false,
    },
    {
        type: "event",
        name: "VaultAddressSet",
        inputs: [
            {
                name: "vault",
                type: "address",
                indexed: true,
            },
        ],
        anonymous: false,
    },
];

export default steakingAbi;
