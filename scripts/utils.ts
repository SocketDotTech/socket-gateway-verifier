import { exit, stdin, stdout } from "process";
import { createInterface } from "readline/promises";

export const confirm = async (message: string) => {
  const rl = createInterface({ input: stdin, output: stdout });
  const answer = await rl.question(message);
  rl.close();
  if (answer.toLowerCase() !== "y") exit(0);
};
