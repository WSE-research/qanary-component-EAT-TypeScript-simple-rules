import { getExpectedEntityType } from "../handler";

describe("getExpectedEntityType", () => {
  it("returns location for 'where' questions", async () => {
    const result = await getExpectedEntityType("Where is Ulm?");
    expect(result?.toString()).toBe("urn:qanary:eat#location");
  });

  it("returns person for 'who' questions", async () => {
    const result = await getExpectedEntityType("Who discovered oxygen?");
    expect(result?.toString()).toBe("urn:qanary:eat#person");
  });

  it("returns datetime for 'when' questions", async () => {
    const result = await getExpectedEntityType("When was the treaty signed?");
    expect(result?.toString()).toBe("urn:qanary:eat#datetime");
  });

  it("returns datetime for 'what time' questions", async () => {
    const result = await getExpectedEntityType("What time is sunset?");
    expect(result?.toString()).toBe("urn:qanary:eat#datetime");
  });

  it("returns datetime for 'what date' questions", async () => {
    const result = await getExpectedEntityType("What date is the event?");
    expect(result?.toString()).toBe("urn:qanary:eat#datetime");
  });

  it("returns number for 'how many' questions", async () => {
    const result = await getExpectedEntityType("How many stations are there?");
    expect(result?.toString()).toBe("urn:qanary:eat#number");
  });

  it("returns number for 'how much' questions", async () => {
    const result = await getExpectedEntityType("How much rainfall fell?");
    expect(result?.toString()).toBe("urn:qanary:eat#number");
  });

  it("returns null for unmatched questions", async () => {
    const result = await getExpectedEntityType("Explain the ozone layer.");
    expect(result).toBeNull();
  });
});

